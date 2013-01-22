module Onigiri
  class Template
    attr_reader :pattern

    def initialize(pattern)
      @pattern      = pattern
    end

    def match(tokens)
      matchset = MatchSet.new()
      index = 0;
      pattern.each do |element|
        
        tagger_name = element.to_s
        optional    = (tagger_name.reverse[0..0] == '?')
        tagger_name = tagger_name.chop if optional
        klass = constantize(tagger_name)
        match = (tokens[index] and tokens[index].has_tag?(klass))

        # binding.pry
        #not optional
        #match - next token, next element
        #no match - return false

        #optional
        #match - next token, next element
        #no match - next element.        
        return false  if (!match and !optional)
        if (optional and !match)
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

    #ignores presence of other tags which are not defined in templates pattern.
    # i.e. for pattern => :a,:b: given tokens => a,x,y,b - the method will match.
    def nonstrict_match(tokens)
      matchset = MatchSet.new()
      index = 0;
      tokens.each do |token|
        break unless pattern[index]
        tagger_name = pattern[index].to_s
        klass = constantize(tagger_name)
        match = token.has_tag?(klass)        
        if match
          matchset << token.get_tag(klass);
          index += 1; 
          next; 
        else
          next
        end
      end

      return false if matchset.size != pattern.size
      return matchset
    end

    def constantize(klass_name)
      camel = klass_name.to_s.gsub(/(^|_)(.)/) { $2.upcase }
      ::Onigiri.const_get camel
    rescue 
      raise OnigiriPain, "there isnt a * #{camel} * tagger class defined"
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

    def size
      matches.size
    end

    def parse_ingredient
      tags = get_tags(Ingredient)
      tags.map{|i| i.type }.join(", ") if tags
    end

    def parse_modifier
      tags = get_tags(Modifier)
      tags.map{|i| i.type }.join(", ") if tags
    end

    def parse_measurement
      tag = get_tag(Measurement)
      tag.type if tag
    end

    def parse_ammount
      tag = get_tag(ScalarMeasurement)
      tag.type if tag
    end

    def get_tags(klass_name)
      matches.select{|x| x.is_a? klass_name}
    end

    def get_tag(klass_name)
      matches.find{|x| x.is_a? klass_name}
    end
  end
end

