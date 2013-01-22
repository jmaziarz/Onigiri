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
        text.gsub!(/\(.*?\)/, '')
        text = Measurement.normalize(text)
        text = Ingredient.normalize(text)
        text = Modifier.normalize(text)
        text = Numerizer.numerize(text)
        text
      end
    end
  end

  #for intenal error reporting
  class OnigiriPain < Exception #:nodoc:
  end 
end
