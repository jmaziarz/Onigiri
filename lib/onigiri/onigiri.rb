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

        matchset = nil
        templates.each do |template|
          break if (matchset = template.matches? tokens)
        end

        if ::Onigiri.debug
          puts "\n+---------------------------------------------------"
          puts "text: #{text}"
          puts "norm: #{normalized_text}"
          tokens.map{|t| puts t.to_s}
          puts "+---------------------------------------------------\n"
        end

        if matchset
          return matchset.result
        else
          return {:status => "Nothing Matched"}
        end
      end

      def templates
        @templates ||= [
          Template.new([:modifier, :ingredient]),
          Template.new([:ingredient, :modifier]),
          Template.new([:scalar, :modifier?, :ingredient]),
          Template.new([:scalar_measurement, :measurement, :modifier?, :modifier?, :ingredient, :modifier?, :modifier?]),
        ]
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
end
