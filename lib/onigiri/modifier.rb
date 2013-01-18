module Onigiri
  class Modifier < Tag
    class << self
      attr_accessor :modifiers

      def scan_for_modifier(token)
        modifiers.each do |variation, normalized_form| 
          token.add_tag(self.new(normalized_form)) if token.name.gsub("_", " ") == variation
        end
      end

      def set_modifier(normalized_form, *variations)
        @modifiers ||= {}
        
        @modifiers[normalized_form] = normalized_form
        variations.each do |variation|
          @modifiers[variation] = normalized_form
        end
      end

      def normalize(text)
        modifiers.each do |variation, normalized_form|
          text.gsub!(variation, normalized_form.gsub(" ", "_"))
        end
        text
      end
    end

    set_modifier 'finely chopped'
  end
end