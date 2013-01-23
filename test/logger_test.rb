require 'helper'

class TestLogger < MiniTest::Unit::TestCase
  def setup
    @logger = Onigiri::Logger 
    @logger.reset
  end

  def test_logs_strings_with_no_ingredient_matched
    @logger.no_ingredient_found("blah")
    assert @logger.redis.lrange('ingredient_errors', 0, -1).include? "blah"
  end

  def test_calculates_all_tag_combinations
    tok_a = Onigiri::Token.new("a")
    tok_b = Onigiri::Token.new("b")

    tag_a = Onigiri::ScalarMeasurement.new(10)
    tag_b = Onigiri::Ingredient.new("pork")
    tag_c = Onigiri::Modifier.new("sliced")

    tok_a.add_tag tag_a 
    tok_a.add_tag tag_b
    tok_b.add_tag tag_c

    tokens = [tok_a, tok_b]

    assert_equal ["ScalarMeasurement Modifier", "Ingredient Modifier"], @logger.tag_combinations_for(tokens)
  end

  def test_logs_token_signatures_which_have_no_matching_template
    tok_a = Onigiri::Token.new("a")
    tok_b = Onigiri::Token.new("b")

    tag_a = Onigiri::ScalarMeasurement.new(10)
    tag_b = Onigiri::Ingredient.new("pork")
    tag_c = Onigiri::Modifier.new("sliced")

    tok_a.add_tag tag_a 
    tok_a.add_tag tag_b
    tok_b.add_tag tag_c

    tokens = [tok_a, tok_b]

    @logger.no_pattern_match(tokens, "5lbs of honey")
    assert_equal ["5lbs of honey"], @logger.redis.lrange("ScalarMeasurement Modifier", 0, -1)
  end
end