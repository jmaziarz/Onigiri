require 'simplecov'
SimpleCov.start

require 'minitest/autorun'
require 'minitest/pride'
require File.expand_path('../../lib/onigiri.rb', __FILE__)


class MiniTest::Unit::TestCase
  #for testing purposes - remove all the ingredeints which were set
  #in the Ingredient class definition
  def before
    Onigiri::Ingredient.ingredients = {}
  end
end