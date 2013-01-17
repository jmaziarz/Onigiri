require 'helper'

class TestTemplateParsing < MiniTest::Unit::TestCase
  def test_scalar_ingredient_parser 
    @template = Onigiri::Template.new([:scalar, :ingredient], :parse_scalar_ingredient)
    @tok_a = Onigiri::Token.new("10")
    @tok_a.add_tag(Onigiri::Scalar.new(10))
    @tok_b = Onigiri::Token.new("banana")
    @tok_b.add_tag(Onigiri::Ingredient.new('banana'))
    assert_equal({:ammount => 10, :ingredient => 'banana'}, @template.parse([@tok_a, @tok_b]))
  end
end