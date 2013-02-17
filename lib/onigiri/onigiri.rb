# encoding: UTF-8 
module Onigiri
  class Onigiri

    class Result 
      STATUS_TYPES =[:success, :ambiguous, :failed]
      attr_accessor :text, :ingredient, :ammount, :measurement, 
                    :modifier, :status, :normalized_text, :score,
                    :scanned_tags

      def parsings
        {:ingredient  => ingredient, 
         :ammount     => ammount, 
         :measurement => measurement, 
         :modifier    => modifier}
      end

      def success?
        status == :success
      end

      def ambiguous?
        status == :ambiguous
      end

      def failed?
        status == :failed
      end

      def status=(sym)
        raise ArgumentError, "expected either :failed or :success but got #{sym}" unless STATUS_TYPES.include?(sym)
        @status = sym
      end


    end

    class << self
      def parse(text, options={})
        normalized_text = normalize(text)

        tokens = tokenize(normalized_text)

        taggers.each do |tagger|
          tagger.scan(tokens)
        end

        tokens = select_tagged_only(tokens) 

        matchset = match_to_template(tokens)

        
        result = Result.new
        result.text = text
        result.normalized_text = normalized_text
        result.scanned_tags = tag_combinations_for(tokens)

        if matchset
          result.status       = :success
          result.ingredient   = matchset.parse_ingredient
          result.measurement  = matchset.parse_measurement
          result.modifier     = matchset.parse_modifier
          result.ammount      = matchset.parse_ammount
        elsif (!matchset and result.scanned_tags.any?)
          result.status = :ambiguous 
        else
          result.status = :failed
        end
        result
      end

      def match_to_template(tokens)
        matchset = nil
        templates[:exact_match].each do |template|
          return matchset if (matchset = template.match tokens)
        end
        
        
        templates[:broad_match].each do |template|
          return matchset if (matchset = template.nonstrict_match tokens)
        end

        return nil
      end

      def templates
        @templates ||=
        {:exact_match =>[Template.new([:modifier, :scalar?, :ingredient]), 
                         Template.new([:ingredient, :ingredient?, :ingredient?]), #Cheese Slices, Avocado, Red Onion Slices
                         Template.new([:ingredient, :modifier]), #turkey sliced
                         Template.new([:measurement, :ingredient, :modifier?]), #small basil leaves
                         Template.new([:scalar, :modifier?, :ingredient]),
                         Template.new([:scalar, :ingredient, :modifier?, :modifier?]),
                         Template.new([:scalar, :ingredient, :modifier?, :measurement]),
                         Template.new([:scalar_measurement, :measurement, :modifier?, :modifier?, :ingredient, :modifier?, :modifier?])],
         
         :broad_match =>[Template.new([:scalar_measurement, :measurement, :modifier, :ingredient]),
                         Template.new([:scalar_measurement, :measurement, :ingredient]),
                         Template.new([:scalar, :modifier, :ingredient]),
                         Template.new([:scalar, :ingredient]),
                         Template.new([:modifier, :ingredient]),
                         Template.new([:ingredient, :modifier, :scalar]),
                         Template.new([:ingredient])]}
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
        text.gsub!(/[,;'"+!*]/, ' ') #replace punctuation with spaces. Double spaces created will be squeezed later.
        text.gsub!(/[`’]/, '') #remove apostrophes but dont replace with space i.e. pimm's => pimms
        text.gsub!(/(\D)\.(\D|\z)/, '\1 \2') #remove periods. Do not remove if acting as a decimal point.
        text = Numerizer.numerize(text)
        text.gsub!(/[[:space:]]/, ' ') #replace any NBSP spaces
        text.gsub!(/(\w)-(\w)/i, '\1 \2') #must follow after numerize - replace hypens in hyphenated words with spaces pizza-topping => pizza topping 
        text.gsub!(/\(.*?\)/, '') #delete brackets and their contents. 
        text.strip! 
        text.squeeze!(" ") #remove double spaces 
        text = Measurement.normalize(text)
        text = Ingredient.normalize(text)
        text = Modifier.normalize(text)
        text.gsub!(/(\d+\.?\d*?)\s+whole/, '\1') #must follower after numerize - remove useage of 'whole' but only after a number/decimal 
        text
      end

      #for debugging
      #given a token can be tagged mutliple times
      #this method works out all the possible combinations 
      #of tags a set of tagged tokens can produce. 
      def tag_combinations_for(tokens)
        tags = tokens.map{|t| t.tags.map(&:klass_name) }
        head, *rest = tags
        return [] if tags.empty?  
        combinations = head.product *rest
        combinations.map{|x| x.join(" ")}
      end
    end
  end

  #for intenal error reporting
  class OnigiriPain < Exception #:nodoc:
  end 
end
