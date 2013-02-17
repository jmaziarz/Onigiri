module Onigiri 
  class Scalar < Tag
    class << self
      def scan(tokens)
        tokens.each_index do |i|
          scan_for_scalar tokens[i], tokens[i + 1]
          scan_for_measurement tokens[i], tokens[i + 1]
        end
      end

      def scan_for_scalar(token, next_token)
        if token.name =~ /^\d+\.?\d*?$/
          token.add_tag self.new(token.name.to_f)
        end
      end

      def scan_for_measurement(token, next_token)
        return unless next_token
        if (token.name =~ /^\d+\.?\d*?$/ && Measurement.normalized_measurements.include?(next_token.name))
          token.add_tag ScalarMeasurement.new(token.name.to_f)
        end
      end
    end
  end

  class ScalarMeasurement < Scalar
  end
end