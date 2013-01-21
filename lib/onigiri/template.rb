module Onigiri
  class Template
    attr_reader :pattern, :parse_method

    def initialize(pattern, parse_method)
      @pattern      = pattern
      @parse_method = parse_method
    end

    def matches?(tokens)
      matchset = MatchSet.new()
      index = 0;
      pattern.each do |element|
        tagger_name = element.to_s
        optional    = (tagger_name.reverse[0..0] == '?')
        tagger_name = tagger_name.chop if optional
        klass = constantize(tagger_name)
        match = (tokens[index] and tokens[index].has_tag?(klass))

        #not optional
        #match - next token, next element
        #no match - return false

        #optional
        #match - next token, next element
        #no match - next element.        
        return false  if (!match and !optional)
        if (optional and !match)
          matchset << tokens[index].get_tag(klass)
          next
        end
        if match
          matchset << tokens[index].get_tag(klass);
          index += 1; 
          next; 
        end
      end

      #if the entire pattern matched, the index should equal the pattern size.
      return false if index != tokens.size
      #if all the tokens matched...
      return matchset
    end

    def constantize(klass_name)
      camel = klass_name.to_s.gsub(/(^|_)(.)/) { $2.upcase }
      ::Onigiri.const_get camel
    end
  end

  class MatchSet
    def matches
      @matches ||= []
    end

    def << (tag)
      matches << tag
    end

    def result
      result = {}
      result[:ingredient]  = parse_ingredient
      result[:modifier]    = parse_modifier
      result[:ammount]     = parse_ammount
      result[:measurement] = parse_measurement
      result
    end

    def parse_ingredient
      get_tags(Ingredient).map{|i| i.type }.join(", ")
    end

    def parse_modifier
      get_tags(Modifier).map{|i| i.type }.join(", ")
    end

    def parse_measurement
      get_tag(Measurement).type
    end

    def parse_ammount
      get_tag(ScalarMeasurement).type
    end

    def get_tags(klass_name)
      matches.select{|x| x.is_a? klass_name}
    end

    def get_tag(klass_name)
      matches.find{|x| x.is_a? klass_name}
    end
  end
end

