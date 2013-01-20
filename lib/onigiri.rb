require "onigiri/version"
require 'onigiri/onigiri'
require 'onigiri/numerizer'
require 'onigiri/token'

require 'onigiri/tag'
require 'onigiri/measurement'
require 'onigiri/template'
require 'onigiri/scalar'
require 'onigiri/ingredient'
require 'onigiri/modifier'

require 'pry'
module Onigiri
  class << self
    attr_accessor :debug
  end
  
  self.debug = true
  # Your code goes here...
end
