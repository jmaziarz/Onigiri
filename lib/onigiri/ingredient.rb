module Onigiri
  class Ingredient < Tag


    class << self
      attr_accessor :ingredients

      def scan(tokens)
        tokens.each do |token|
          scan_for_ingredient token
        end
      end

      def scan_for_ingredient(token)
        ingredients.each do |correct_form, variations|
          variations.each do |var|
            if token.name.gsub("_", " ") == var
              token.add_tag new(correct_form)
              return
            end
          end
        end
      end
      
      # Checkes given text for any multi word ingredients and replaces them
      # with the dasherized correct form i.e. cherry tomato => cherry_tomato
      # This prevents such an ingredient being spliced into multiple tokens 
      def normalize(text)
        normalized = text
        ingredients.each do |correct_form, variations|
          variations.each do |v|
            normalized.gsub!(v, correct_form.gsub(" ", "_"))
          end
        end
        normalized
      end

      def set_ingredient(correct_form, *variations)
        @ingredients ||={}
        dasherized_form = correct_form.gsub(" ", "_") #dasherize multiword ingredients to prevent dicing by their spaces into multiple tokens later on.
        @ingredients[correct_form] = variations
        @ingredients[correct_form].push correct_form #and remember to add dasherized_form to variations for use in token scanning later
      end
    end
  end
end