module Onigiri
  class Tag
    attr_accessor :type
    def initialize(type)
      @type = type
    end

    def to_s
      "#{type.to_s} (#{self.class.to_s.gsub(/.+::(\w+)$/, '\1')})"
    end
  end
end