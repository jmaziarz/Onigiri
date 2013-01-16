require 'helper'


class TestMeasurement < MiniTest::Unit::TestCase
  def test_normalizes_measurements
    measurement_variations = [
      ["c", "cup"],
      ["fluid ounce", "fluid_ounce"],
      ["gal", "gallon"],
      ["oz", "ounce"]
    ]

    measurement_variations.each do |variation, normalized_form|
      assert_equal normalized_form, Onigiri::Measurement.normalize(variation)
    end
  end
end