require 'simplecov'
SimpleCov.start

require 'minitest/autorun'
require 'minitest/pride'
require File.expand_path('../../lib/onigiri.rb', __FILE__)

Onigiri.debug = false
