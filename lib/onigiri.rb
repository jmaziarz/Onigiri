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

require 'redis'
require 'redis/namespace'

require 'pry'
module Onigiri
  class << self
    attr_accessor :debug, :log_failures
  end
  
  self.debug = true
  self.log_failures = true #log failed parsings to improve the gem
end
