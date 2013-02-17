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
          token.add_tag(self.new(normalized_form)) if token.name == variation
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
          text.gsub!(/\b#{variation}\b/, normalized_form.gsub(" ", "_"))
        end
        text
      end
    end

    set_modifier 'beaten'
    set_modifier 'boiled'
    set_modifier 'crushed'
    set_modifier 'chopped'
    set_modifier 'chilled'
    set_modifier 'coarse'
    set_modifier 'cooked'
    set_modifier 'cracked', 'fresh-?cracke?d?'
    set_modifier 'crumbled'
    set_modifier 'diced'
    set_modifier 'dried', 'dry'
    set_modifier 'finely sliced'
    set_modifier 'finely chopped'
    set_modifier 'finely diced'
    set_modifier 'fresh'
    set_modifier 'frozen'
    set_modifier 'grated'
    set_modifier 'grainy'
    set_modifier 'ground'
    set_modifier 'heated'
    set_modifier 'juiced'
    set_modifier 'juice of'
    set_modifier 'minced'
    set_modifier 'peeled'
    set_modifier 'ripe'
    set_modifier 'refrigerated'
    set_modifier 'salted'
    set_modifier 'seeded'
    set_modifier 'separated'
    set_modifier 'sliced'
    set_modifier 'shredded', 'shredd?ed'
    set_modifier 'squeezed'
    set_modifier 'smoked', 'smoke?y' 
    set_modifier 'trimmed'
    set_modifier 'toasted'
    set_modifier 'uncooked'
    set_modifier 'unsalted'
    set_modifier 'unsweetened'
    set_modifier 'warmed'
    set_modifier 'wedges'
    set_modifier 'zest', 'zest of'
  end
end