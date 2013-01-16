module Onigiri
  class Tag
    class << self
      attr_accessor :type

      def initialize(type)
        @type = type
      end
    end
  end
end