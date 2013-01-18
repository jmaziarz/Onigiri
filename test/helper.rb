require 'simplecov'
SimpleCov.start

require 'minitest/autorun'
require 'minitest/pride'
require File.expand_path('../../lib/onigiri.rb', __FILE__)


class MiniTest::Unit::TestCase
  #for testing purposes - remove all the ingredeints, modifiers which were set
  #in their respective class definitions.
  def before
    Onigiri::Ingredient.ingredients = {}
    Onigiri::Modifier.modifiers = {}
  end
end