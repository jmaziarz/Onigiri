module Onigiri
  class Template
    attr_reader :pattern, :parse_method

    def initialize(pattern, parse_method)
      @pattern      = pattern
      @parse_method = parse_method
    end

    def matches?(tokens)
      index = 0;
      tagged_count = 0;
      tokens.each do |token|
        break if index == pattern.size
        tagger_name = pattern[index]
        klass = constantize(tagger_name)
        if token.get_tag(klass)
          tagged_count += 1
          index += 1 
        end
      end

      #if the entire pattern matched, the index should equal the pattern size.
      return false if index != pattern.size
      #if all the tokens matched...
      return false if tagged_count != tokens.size
      return true
    end

    def parse(tokens)
      self.send(parse_method.to_sym, tokens)
    end

    def parse_scalar_ingredient(tokens)
      result = {}
      result[:ammount]    = tokens[0].get_tag(Scalar).type
      result[:ingredient] = tokens[1].get_tag(Ingredient).type
      result
    end

    def parse_scl_msr_ing(tokens)
      result = {}
      result[:ammount]     = tokens[0].get_tag(Scalar).type
      result[:measurement] = tokens[1].get_tag(Measurement).type
      result[:ingredient]  = tokens[2].get_tag(Ingredient).type
      result
    end

    #3 tbsp unsweetened applesauce
    def parse_scl_msr_mod_ing(tokens)
      result = {}
      result[:ammount]     = tokens[0].get_tag(Scalar).type
      result[:measurement] = tokens[1].get_tag(Measurement).type
      result[:modifier]    = tokens[2].get_tag(Modifier).type
      result[:ingredient]  = tokens[3].get_tag(Ingredient).type
      result
    end

    # 15 g  goat cheese, crumbled
    def parse_scl_msr_ing_mod(tokens)
      result = {}
      result[:ammount]     = tokens[0].get_tag(Scalar).type
      result[:measurement] = tokens[1].get_tag(Measurement).type
      result[:ingredient]  = tokens[2].get_tag(Ingredient).type
      result[:modifier]    = tokens[3].get_tag(Modifier).type
      result
    end

    # banana chopped
    def parse_ing_mod(tokens)
      result = {}
      result[:ingredient]  = tokens[0].get_tag(Ingredient).type
      result[:modifier]    = tokens[1].get_tag(Modifier).type
      result[:ammount]     = 1
      result
    end

    # chopped banana
    def parse_mod_ing(tokens)
      result = {}
      result[:modifier]    = tokens[0].get_tag(Modifier).type
      result[:ingredient]  = tokens[1].get_tag(Ingredient).type
      result[:ammount]     = 1
      result
    end


    def constantize(klass_name)
      ::Onigiri.const_get klass_name.to_s.capitalize
    end
  end
end

