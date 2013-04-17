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
        word_size = token.name.split("_").size

        humanized_token_name = token.name.gsub("_", " ")
        if correct_forms.include? humanized_token_name
          token.add_tag new(humanized_token_name)
          return
        end
      end

      # Checkes given text for any multi word measurements and replaces them
      # with the dasherized correct form i.e. 9 ounce can => 9_ounce_can
      # This prevents such a measurement being mistaken for simple 'ounce' 
      # TODO - same as ingredient class - extract out.
      def normalize(text)
        normalized = text
        word_counts = measurements.keys.sort.reverse
        word_counts.each do |word_count|
          measurements[word_count].each do |variation, correct_form|

            normalized.gsub!(/\b#{variation}\b/i, correct_form.gsub(" ", "_"))
          end
        end
        normalized
      end

      def set_measurement(correct_form, *variations)
        @measurements ||={}
        variations.each do |v|
          set_by_word_count(v, correct_form)
        end
        set_by_word_count(correct_form, correct_form)
      end

      def set_by_word_count(variation, correct_form)
        word_count = variation.split(" ").size
        @measurements[word_count] ||= {}
        @measurements[word_count][variation] = correct_form
      end

      def correct_forms
        @correct_forms ||= measurements.values.map(&:values).flatten.uniq
      end

      def normalized_measurements
        @normalized_measurements ||= measurements.values.uniq
      end
    end

    # english units
    set_measurement "cup", "c", "cup", "cups"
    set_measurement "fl oz", "fl. oz.", "fl oz", "fluid ounce", "fluid ounces"
    set_measurement "gal", "gal", "gal.", "gallon", "gallons"
    set_measurement "oz", "oz", "ounce", "ounces"
    set_measurement "pt", "pt", "pint", "pints"
    set_measurement "lb", "lb", "lb.", "lbs", "lbs.", "pound", "pounds"
    set_measurement "qt", "qt", "qts", "quart", "quarts"
    set_measurement "tbsp", "tbsp", "T", "tablespoon", "tablespoons"
    set_measurement "tsp", "tsp", "t", "teaspoon", "teaspoons"
    
    set_measurement '9 oz can',  '9-ounce cans?', '9 ounce cans?'
    set_measurement '15 oz can', '15-ounce cans?', '15 ounce cans?'
    set_measurement '21 oz can', '21-ounce cans?', '21 ounce cans?'

    set_measurement '10 oz bag', '10-ounce bags?', '10 ounce bags?'
    
    set_measurement 'can', 'cans', 'tin', 'tins'
    set_measurement 'jar', 'jars'
    set_measurement '12 oz jar', '12-?\s?ounce jars?'
    # metric units
    set_measurement "g", "g", "g.", "gr", "gr.", "gram", "grams"
    set_measurement "kg", "kg", "kilogram", "kilograms"
    set_measurement "ltr", "l", "ltr", "liter", "liters", "litre"
    set_measurement "mg", "mg", "mg.", "milligram", "milligrams"
    set_measurement "ml", "ml", "ml.", "milliliter", "milliliters"

    # random units for veg n stuff
    set_measurement "clove", "cloves? of garlic", "garlic cloves?"
    set_measurement "head"
    set_measurement "handfull", "handfull?s?"
    
    set_measurement 'sprig', 'sprigs?'
    set_measurement 'leaf',   'leafs?', 'leaves'

    set_measurement 'bar', 'bars'
    set_measurement 'box', 'boxes'
    set_measurement 'cube', 'cubes'



    set_measurement "slice", "slices?"
    set_measurement "strip", "strips?"

    set_measurement "medium", 'med\.?'
    set_measurement "large", 'lrg\.?', 'large'
    set_measurement "small", 'sml\.?'
  end
end