require 'helper'


class TestIngredient < MiniTest::Unit::TestCase
  def test_sets_ingredient
    Onigiri::Ingredient.set_ingredient 'banana', 'bananaz'
    assert Onigiri::Ingredient.ingredients.has_key? 'banana'
    assert Onigiri::Ingredient.ingredients['banana'].include? 'bananaz'
  end
end