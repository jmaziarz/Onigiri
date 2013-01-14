require 'helper'

class TestNumerizer < MiniTest::Unit::TestCase
  def setup
    
  end

  def test_converts_direct_numbers
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

  def test_converts_simple_tens
    numbers_in_tens = [
      ["ten","10"],
      ["twenty", "20"],
      ["thirty", "30"],
      ["fourty", "40"],
      ["fifty",  "50"],
      ["sixty",  "60"],
      ["seventy", "70"],
      ["eighty", "80"],
      ["ninety", "90"]
    ]

    numbers_in_tens.each do |word, number|
       assert_equal number, Onigiri::Numerizer.numerize(word)
    end
  end

  def test_converts_complex_tens
    complex_numbers_in_tens = [
          ["twenty three", "23"],
          ["thirty four", "34"],
          ["sixty nine", "69"]
        ]

    complex_numbers_in_tens.each do |word, number|
      assert_equal number, Onigiri::Numerizer.numerize(word)
    end
  end
end