require 'helper'

class TestOnigiri < MiniTest::Unit::TestCase
  def setup
    
  end

  def test_normalized_text_has_no_punctuation
    text = "the, end."
    assert_equal "the end", Onigiri::Onigiri.normalize(text)
  end

  def test_tokenizes_text
    text = "one two"
    tokens = Onigiri::Onigiri.tokenize(text)
    assert_equal "one", tokens.first.name
    assert_equal "two", tokens.last.name
  end

  def test_selects_tagged_tokens_only
    tok_a = Onigiri::Token.new("10")
    tok_a.add_tag(:scalar)
    tok_b = Onigiri::Token.new("grams")
    assert_equal [tok_a], Onigiri::Onigiri.select_tagged_only([tok_a, tok_b])
  end

  def test_parsing
    Onigiri::Ingredient.set_ingredient 'banana'
    expected = {:ammount => 10, :ingredient => 'banana', :measurement => 'pound'}
    ["10 lbs of banana"].each do |text|
      result = Onigiri::Onigiri.parse(text)
      assert_equal(expected[:ammount],      result[:ammount])
      assert_equal(expected[:ingredient],   result[:ingredient])
      assert_equal(expected[:measurement],  result[:measurement])
    end
  end
end