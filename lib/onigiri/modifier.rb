module Onigiri
  class Modifier < Tag
    class << self
      attr_accessor :modifiers

      def scan(tokens)
        tokens.each do |token|
          scan_for_modifier token
        end
      end

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
    set_modifier 'crushed'
    set_modifier 'chopped'
    set_modifier 'grated'
    set_modifier 'squeezed'
    set_modifier 'sliced'
    set_modifier 'finely sliced'
    set_modifier 'chilled'
    set_modifier 'frozen'
    set_modifier 'warmed'
    set_modifier 'heated'
    set_modifier 'boiled'
  end
end