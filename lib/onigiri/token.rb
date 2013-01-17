module Onigiri
  class Token
    attr_accessor :name, :tags

    def initialize(name)
      @name = name
    end

    def add_tag(tag)
      tags.push tag
    end

    def tags
      @tags ||= []
    end

    def get_tag(class_type)
      tags.find{|x| x.is_a? class_type}
    end
  end
end