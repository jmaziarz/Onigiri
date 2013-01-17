module Onigiri 
  class Scalar < Tag
    class << self
      def scan(tokens)
        tokens.each do |token|
          scan_for_scalar token
        end
      end

      def scan_for_scalar(token)
        if token.name =~ /^\d+$/
          token.add_tag self.new(token.name.to_i)
        end
      end
    end
  end
end