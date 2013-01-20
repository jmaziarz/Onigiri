module Onigiri
  class Measurement < Tag
    class << self
      attr_accessor :measurements

      def scan(tokens)
        tokens.each do |token|
          scan_for_measurement token
        end
      end

      def scan_for_measurement(token)
        normalized_measurements.each do |measurement|
          if token.name == measurement
            name = token.name.gsub('_', ' ') #remove any underscore dashes for multi word ingredients i.e. fluid_ounce => fluid ounce
            token.add_tag self.new(name)
          end
        end
      end

      def normalize(text)
        measurements.each do |variation, normalized_form|
          return text if text.gsub!(/\b#{variation}\b/i, normalized_form)
        end
        text
      end

      def set_measurement(normalized_form, *variations)
        @measurements ||={}
        variations.each do |variation|
          @measurements[variation] = normalized_form
        end
      end

      def normalized_measurements
        @normalized_measurements ||= measurements.values.uniq
      end
    end

    # english units
    set_measurement "cup", "c", "cup", "cups"
    set_measurement "fluid_ounce", "fl. oz.", "fl oz", "fluid ounce", "fluid ounces"
    set_measurement "gallon", "gal", "gallon", "gallons"
    set_measurement "ounce", "oz", "ounce", "ounces"
    set_measurement "pint", "pt", "pint", "pints"
    set_measurement "pound", "lb", "lb.", "pound", "pounds"
    set_measurement "quart", "qt", "qts", "quart", "quarts"
    set_measurement "tablespoon", "tbsp", "T", "tablespoon", "tablespoons"
    set_measurement "teaspoon", "tsp", "t", "teaspoon", "teaspoons"
    # metric units
    set_measurement "gram", "g", "g.", "gr", "gr.", "gram", "grams"
    set_measurement "kilogram", "kg", "kilogram", "kilograms"
    set_measurement "liter", "l", "liter", "liters"
    set_measurement "milligram", "mg", "mg.", "milligram", "milligrams"
    set_measurement "milliliter", "ml", "ml.", "milliliter", "milliliters"
  end
end