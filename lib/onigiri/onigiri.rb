module Onigiri
  class Onigiri
    class << self
      def parse(text)
        normalized_text = normalize(text)

        tokens = tokenize(normalized_text)

        taggers.each do |tagger|
          tagger.scan(tokens)
        end

        tokens = select_tagged_only(tokens) 

        if ::Onigiri.debug
          puts "\n+---------------------------------------------------"
          puts "text: #{text}"
          puts "norm: #{normalized_text}"
          tokens.map{|t| puts t.to_s}
          puts "+---------------------------------------------------\n"
        end

        matchset = nil
        templates[:exact_match].each do |template|
          return matchset.result if (matchset = template.match tokens)
        end
  
        templates[:broad_match].each do |template|
          return matchset.result if (matchset = template.nonstrict_match tokens)
        end

        if ::Onigiri.log_failures
          Logger.no_ingredient_found(text) unless tokens.find{|x| x.has_tag?(Ingredient) }
          Logger.no_pattern_match(tokens, text) 
        end

        return nil
      end

      def templates
        @templates ||=
        {:exact_match =>[Template.new([:modifier, :ingredient]),
                         Template.new([:ingredient, :modifier]),
                         Template.new([:scalar, :modifier?, :ingredient]),
                         Template.new([:scalar_measurement, :measurement, :modifier?, :modifier?, :ingredient, :modifier?, :modifier?])],
         
         :broad_match =>[Template.new([:scalar_measurement, :measurement, :modifier, :ingredient]),
                         Template.new([:scalar_measurement, :measurement, :ingredient]),
                         Template.new([:scalar, :modifier, :ingredient]),
                         Template.new([:scalar, :ingredient]),
                         Template.new([:modifier, :ingredient]),
                         Template.new([:ingredient, :modifier, :scalar])]}
      end

      def taggers
        @taggers ||= [Scalar, Measurement, Ingredient, Modifier]
      end

      def tokenize(text)
        text.split(" ").map {|segment| Token.new(segment)}
      end

      def select_tagged_only(tokens)
        tokens.select{|t| !t.tags.empty? }
      end

      def normalize(str)
        text = str.dup
        text.downcase!
        text.gsub!(/[.,]/, '') 
        text.gsub!(/\(.*?\)/, '') #remove brackets and their contents. 
        text = Measurement.normalize(text)
        text = Ingredient.normalize(text)
        text = Modifier.normalize(text)
        text = Numerizer.numerize(text)
        text.gsub!(/(\d+\.?\d*?)\s+whole/, '\1') #remove useage of 'whole' but only after a number/decimal 
        text
      end
    end
  end

  #for intenal error reporting
  class OnigiriPain < Exception #:nodoc:
  end 

  class Logger
    class << self
      def redis
        @redis
      end

      def redis=(redis)
        @redis = redis
      end

      def reset
        redis.flushall
      end

      #store strings which dont have matched ingredeint (store string with all matched tags removed?)
      def no_ingredient_found(string)
        redis.lpush 'ingredient_errors', string
      end
  
      #store token signatures which dont have a corresponding pattern. 
      def no_pattern_match(tokens, string)
        combinations = tag_combinations_for(tokens)
        combinations.each do |combo|
          redis.sadd(combo, string)
          redis.zadd('pattern_count', redis.scard(combo).to_s, combo)
        end
      end

      def tag_combinations_for(tokens)
        tags = tokens.map{|t| t.tags.map(&:klass_name) }
        head, *rest = tags
        combinations = head.product *rest
        combinations.map{|x| x.join(" ")}
      end

      def report_ingredient_failures
        redis.lrange('ingredient_errors', 0, -1).join("\n")
      end

      def report_pattern_failures
        str = "===========\nPattern failures\n============\n"
        redis.zrevrange('pattern_count', 0, -1).each do |pattern|
          puts "#{redis.zscore('pattern_count', pattern)} - #{pattern}"
          puts "-------------------------------------"
          redis.smembers(pattern).each {|x| puts x }
          puts "\n"
        end
      end
    end
  end
end
