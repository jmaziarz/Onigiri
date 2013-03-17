require 'helper'


class TestMeasurement < MiniTest::Unit::TestCase
  def test_normalizes_measurements
    measurement_variations = [
      ["c", "cup"],
      ["fluid ounce", "fl_oz"],
      ["gallon", "gal"],
      ["ounce", "oz"],
      ["15 ounce cans", "15_oz_can"]
    ]

    measurement_variations.each do |variation, normalized_form|
      assert_equal normalized_form, Onigiri::Measurement.normalize(variation)
    end
  end

  def test_does_not_make_partial_matches_when_normalizing
    assert_equal "12_oz_jar", Onigiri::Measurement.normalize("12-ounce jar")
  end

  def test_scan_for_measurements_tags_token_with_name
    token = Onigiri::Token.new("fl_oz")
    Onigiri::Measurement.scan_for_measurement(token)
    assert_equal "fl oz", token.tags.first.type
  end
end