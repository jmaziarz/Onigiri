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

        matching_template = nil
        templates.each do |template|
          if template.matches? tokens
            matching_template = template
            break
          end
        end

        if matching_template
          return matching_template.parse(tokens)
        else
          return {:status => "Nothing Matched"}
        end
      end


      def templates
        @templates ||= [
          Template.new([:scalar, :ingredient], :parse_scalar_ingredient),
          Template.new([:scalar, :measurement, :ingredient], :parse_scl_msr_ing)
        ]
      end

      def taggers
        @taggers ||= [Scalar, Measurement, Ingredient]
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
        text.gsub!(/[.,]/, "")
        text = Measurement.normalize(text)
        text = Ingredient.normalize(text)
        text
      end
    end
  end
end
