require 'helper'


class TestIngredient < MiniTest::Unit::TestCase
  def test_sets_ingredient
    Onigiri::Ingredient.set_ingredient 'banana', 'bananaz'
    assert Onigiri::Ingredient.ingredients.has_key? 'banana'
    assert Onigiri::Ingredient.ingredients['banana'].include? 'bananaz'
  end

  def test_tags_tokens
    Onigiri::Ingredient.set_ingredient 'banana', 'bazza'
    tok_a = Onigiri::Token.new("bazza")
    Onigiri::Ingredient.scan_for_ingredient(tok_a)
    assert_equal true, tok_a.tags.first.is_a?(Onigiri::Ingredient)
    assert_equal "banana", tok_a.tags.first.type
  end
end