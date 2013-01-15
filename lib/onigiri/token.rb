module Onigiri
  class Token
    attr_accessor :name, :tags

    def initialize(name)
      @name = name
    end

    def add_tag(name)
      tags.push name.to_sym
    end

    def tags
      @tags ||= []
    end
  end
end