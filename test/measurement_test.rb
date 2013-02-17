require 'helper'


class TestMeasurement < MiniTest::Unit::TestCase
  def test_normalizes_measurements
    measurement_variations = [
      ["c", "cup"],
      ["fluid ounce", "fluid_ounce"],
      ["gal", "gallon"],
      ["oz", "ounce"],
      ["15 ounce cans", "15_ounce_can"]

    ]

    measurement_variations.each do |variation, normalized_form|
      assert_equal normalized_form, Onigiri::Measurement.normalize(variation)
    end
  end

  def test_scan_for_measurements_tags_token_with_name
    token = Onigiri::Token.new("fluid_ounce")
    Onigiri::Measurement.scan_for_measurement(token)
    assert_equal "fluid ounce", token.tags.first.type
  end
end