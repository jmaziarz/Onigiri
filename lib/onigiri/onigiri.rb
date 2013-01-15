module Onigiri
  class Onigiri
    class << self
      def parse(text)

        # tokens = tokenize(text)
        # [Tags].each do |tag|
        #   tag.tag(tokens)
        # end

        normalized_text = normalize(text)

        tokens = tokenize(normalized_text)



        templates.each do |template|
          if template.matches? tokens
            result = Parser.send template.parse_method, tokens
          else 
            next
          end
        end
      end


      def templates
        # @templates ||= [
        #   Template.new(:scalar, :measurement, :ingredient_description)
        #   Template.new(:fraction, :measurement, :ingredient_description)
        #   Template.new(:float, :measurement, :ingredient_description)
        #   Template.new(:ingredient_description, :seperator, :scalar)
        #   Template.new(:ingredient_description, :seperator, :fraction)
        #   Template.new(:scalar, :measurement, :ingredient_description)
        #   Template.new(:scalar, :measurement, :ingredient_description)

        # ]

      end

      def tokenize(text)
        text.split(" ").map {|segment| Token.new(segment)}
      end

      def normalize(text)
        text.downcase!
        text.gsub!(/[.,]/, "")
        text
      end
    end
  end
end
