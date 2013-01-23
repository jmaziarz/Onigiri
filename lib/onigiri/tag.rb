module Onigiri
  class Tag
    attr_accessor :type
    def initialize(type)
      @type = type
    end

    def klass_name
      self.class.to_s.gsub(/.+::(\w+)$/, '\1')
    end

    def to_s
      "#{type.to_s} (#{klass_name})"
    end
  end
end