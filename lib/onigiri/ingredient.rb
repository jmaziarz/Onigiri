module Onigiri
  class Ingredient
    class << self
      attr_reader :ingredients

      def set_ingredient(correct_form, *variations)
        @ingredients ||={}
        @ingredients[correct_form] = variations
      end
    end
  end
end