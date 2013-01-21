module Onigiri
  class Onigiri
    class << self
      def parse(text)
        normalized_text = normalize(text)

        tokens = tokenize(normalized_text)

        taggers.each do |tagger|
          tagger.scan(tokens)
        end

        tokens = select_tagged_only(tokens) 

        matching_template = nil
        templates.each do |template|
          if template.matches? tokens
            matching_template = template
            break
          end
        end

        if ::Onigiri.debug

          puts "\n+---------------------------------------------------"
          puts "text: #{text}"
          puts "norm: #{normalized_text}"
          tokens.map{|t| puts t.to_s}
          puts "+---------------------------------------------------\n"
        end

        if matching_template
          return matching_template.parse(tokens)
        else
          return {:status => "Nothing Matched"}
        end
      end

      def templates
        @templates ||= [
          Template.new([:modifier, :ingredient], :parse_mod_ing),
          Template.new([:ingredient, :modifier], :parse_ing_mod),
          Template.new([:scalar, :ingredient], :parse_scalar_ingredient),
          Template.new([:scalar_measurement, :measurement, :ingredient], :parse_sclmsr_msr_ing),
          Template.new([:scalar_measurement, :measurement, :modifier, :ingredient], :parse_sclmsr_msr_mod_ing),
          Template.new([:scalar_measurement, :measurement, :ingredient, :modifier], :parse_sclmsr_msr_ing_mod)
        ]
      end

      def taggers
        @taggers ||= [Scalar, Measurement, Ingredient, Modifier]
      end

      def tokenize(text)
        text.split(" ").map {|segment| Token.new(segment)}
      end

      def select_tagged_only(tokens)
        tokens.select{|t| !t.tags.empty? }
      end

      def normalize(str)
        text = str.dup
        text.downcase!
        text.gsub!(/[.,]/, '')
        text.gsub!(/\(.*?\)/, '')
        text = Measurement.normalize(text)
        text = Ingredient.normalize(text)
        text = Modifier.normalize(text)
        text = Numerizer.numerize(text)
        text
      end
    end
  end
end
