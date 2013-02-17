require 'helper'


class TestIngredient < MiniTest::Unit::TestCase
  def test_sets_ingredient
    Onigiri::Ingredient.set_ingredient 'banana', 'bananaz'
    assert Onigiri::Ingredient.ingredients[1].has_key? 'bananaz'
    assert_equal 'banana', Onigiri::Ingredient.ingredients[1]['bananaz']
  end

  def test_sets_ingredients_by_their_word_count
    Onigiri::Ingredient.set_ingredient 'cherry tomato'
    assert Onigiri::Ingredient.ingredients[2].has_key? 'cherry tomato'
  end

  def test_underscores_multi_word_ingredients_to_normalize
    text = "10 lbs of cherry tomato"
    Onigiri::Ingredient.set_ingredient 'cherry tomato'
    assert_equal "10 lbs of cherry_tomato", Onigiri::Ingredient.normalize(text)
  end

  def test_normalizes_ingredients_with_regexps
    string = 'testABCDtest'
    Onigiri::Ingredient.set_ingredient 'success', 'test\w\w\w\wtest'
    result = Onigiri::Ingredient.normalize(string)
    assert_equal 'success', result
  end

  def test_tags_tokens_with_correct_form_name
    Onigiri::Ingredient.set_ingredient 'banana'
    tok_a = Onigiri::Token.new("banana")
    Onigiri::Ingredient.scan_for_ingredient(tok_a)
    assert_equal true, tok_a.tags.first.is_a?(Onigiri::Ingredient)
    assert_equal "banana", tok_a.tags.first.type
  end

end