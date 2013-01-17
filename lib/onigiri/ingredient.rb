module Onigiri
  class Ingredient < Tag
    class << self
      attr_reader :ingredients

      def scan(tokens)
        tokens.each do |token|
          scan_for_ingredient token
        end
      end

      def scan_for_ingredient(token)
        ingredients.each do |correct_form, variations|
          variations.each do |var|
            if token.name == var
              token.add_tag new(correct_form)
              return
            end
          end
        end
      end

      def set_ingredient(correct_form, *variations)
        @ingredients ||={}
        @ingredients[correct_form] = variations
        @ingredients[correct_form].push correct_form #add the correct_form to variations to ease token matching
      end
    end
  end
end