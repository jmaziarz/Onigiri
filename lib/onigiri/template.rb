module Onigiri
  class Template
    attr_reader :pattern, :parse_method

    def initialize(pattern, parse_method)
      @pattern      = pattern
      @parse_method = parse_method
    end

    def matches?(tokens)
      index = 0;
      tokens.each do |token|
        if (pattern[index] and token.tags.include?(pattern[index]))
          index += 1 
        end
      end

      #if the entire pattern matched, the index should equal the pattern size.
      return false if index != pattern.size
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
  end
end

