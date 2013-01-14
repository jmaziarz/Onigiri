require 'helper'

class TestNumerizer < MiniTest::Unit::TestCase
  def setup
    
  end

  def test_converts_integers
    numbers = [
      ["one","1"],
      ["four","4"],
      ["eleven","11"],
      ["nineteen","19"]
    ]

    numbers.each do |key, value|
      assert_equal value, Onigiri::Numerizer.numerize(key)
    end
  end
end