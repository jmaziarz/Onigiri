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

  def test_converts_fractions_to_decimal 
    fractions = [
      ["1/2", "0.5"],
      ["1/3", "0.33"],
      ["1/4", "0.25"],
      ["1 1/2", "1.5"],
      ["10 1/4", "10.25"]
    ]

    fractions.each do |fraction, decimal|
      assert_equal decimal, Onigiri::Numerizer.numerize(fraction)
    end
  end

  def test_chooses_first_number_in_a_range
    ranges = [
      ["1-2", "1"],
      ["2 - 3", "2"],
      ["2 or 3", "2"],
      ["two or three", "2"],
      ["two to three", "2"],
      ["0.25 to 0.5", "0.25"]
    ]

    ranges.each do |range, choosen|
      assert_equal choosen, Onigiri::Numerizer.numerize(range)
    end
  end
end