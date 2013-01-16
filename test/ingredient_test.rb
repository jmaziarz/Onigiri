require 'helper'


class TestIngredient < MiniTest::Unit::TestCase
  def test_sets_ingredient
    Onigiri::Ingredient.set_ingredient 'banana', 'bananaz'
    assert Onigiri::Ingredient.ingredients.has_key? 'banana'
    assert Onigiri::Ingredient.ingredients['banana'].include? 'bananaz'
  end

  def test_tags_tokens
    Onigiri::Ingredient.set_ingredient 'banana'
    tok_a = Onigiri::Token.new("banana")
    Onigiri::Ingredient.scan([tok_a])
    assert_equal true, tok_a.tags.include?(:ingredient)
  end
end