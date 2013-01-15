require 'helper'


class TestMeasurementizer < MiniTest::Unit::TestCase
  def test_normalizes_measurements
    measurement_variations = [
      ["c", "cup"],
      ["fluid ounce", "fluid_ounce"],
      ["gal", "gallon"],
      ["oz", "ounce"]
    ]

    assert_equal "cup", Onigiri::Measurementizer.normalize('c')

    measurement_variations.each do |variation, normalized_form|
      assert_equal normalized_form, Onigiri::Measurementizer.normalize(variation)
    end
  end
end