require 'helper'


class TestIngredient < MiniTest::Unit::TestCase
  def test_sets_ingredient
    Onigiri::Ingredient.set_ingredient 'banana', 'bananaz'
    assert Onigiri::Ingredient.ingredients.has_key? 'banana'
    assert Onigiri::Ingredient.ingredients['banana'].include? 'bananaz'
  end

  def test_sets_ingredients_of_multiple_words
    Onigiri::Ingredient.set_ingredient 'cherry tomato'
    assert Onigiri::Ingredient.ingredients.has_key? 'cherry tomato'
  end

  def test_underscores_multi_word_ingredients_to_normalize
    text = "10 lbs of cherry tomato"
    Onigiri::Ingredient.set_ingredient 'cherry tomato'
    assert_equal "10 lbs of cherry_tomato", Onigiri::Ingredient.normalize(text)
  end

  def test_tags_tokens
    Onigiri::Ingredient.set_ingredient 'banana', 'bazza'
    tok_a = Onigiri::Token.new("bazza")
    Onigiri::Ingredient.scan_for_ingredient(tok_a)
    assert_equal true, tok_a.tags.first.is_a?(Onigiri::Ingredient)
    assert_equal "banana", tok_a.tags.first.type
  end
end