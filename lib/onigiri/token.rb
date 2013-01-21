module Onigiri
  class Token
    attr_accessor :name, :tags

    def initialize(name)
      @name = name.gsub("_", " ")
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

    def has_tag?(class_type)
      get_tag(class_type) ? true : false
    end

    def to_s
      str = "name: #{name} | "
      str << tags.each {|t| t.to_s }.join(" - ")
      str
    end
  end
end