require 'helper'

class TestTemplate < MiniTest::Unit::TestCase

  def setup 
    @template = Onigiri::Template.new([:scalar, :measurement], :standard_parser)
    @tok_a = Onigiri::Token.new("10")
    @tok_a.add_tag(:scalar)
    @tok_b = Onigiri::Token.new("grams")
    @tok_b.add_tag(:measurement)
  end

  def test_has_a_pattern
    assert_equal [:scalar, :measurement], @template.pattern
  end

  def test_template_matches_tokens
    assert @template.matches? [@tok_a, @tok_b]
  end

  def test_template_does_not_match_tokens_in_wrong_order
    refute @template.matches? [@tok_b, @tok_a]
  end

  def test_template_does_not_make_partial_matches_with_tokens
    refute @template.matches? [@tok_a]
  end
end