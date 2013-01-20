require 'helper'

class TestTemplate < MiniTest::Unit::TestCase

  def setup 
    @template = Onigiri::Template.new([:scalar_measurement, :measurement], :some_parser)
    @tok_a = Onigiri::Token.new("10")
    @tok_a.add_tag(Onigiri::ScalarMeasurement.new(10))
    @tok_b = Onigiri::Token.new("grams")
    @tok_b.add_tag(Onigiri::Measurement.new("grams"))
  end

  def test_has_a_pattern
    assert_equal [:scalar_measurement, :measurement], @template.pattern
  end

  def test_template_matches_tokens
    assert @template.matches? [@tok_a, @tok_b]
  end

  def test_template_does_not_match_tokens_in_wrong_order
    refute @template.matches? [@tok_b, @tok_a]
  end

  def test_template_match_fails_if_unmatched_pattern_parts_exist
    refute @template.matches? [@tok_a]
  end
end