require 'helper'

class TestTemplateParsing < MiniTest::Unit::TestCase
  def test_scalar_ingredient_parser 
    template = Onigiri::Template.new([:scalar, :ingredient], :parse_scalar_ingredient)
    
    tok_a = Onigiri::Token.new("10")
    tok_a.add_tag(Onigiri::Scalar.new(10))

    tok_b = Onigiri::Token.new("banana")
    tok_b.add_tag(Onigiri::Ingredient.new('banana'))

    assert_equal({:ammount => 10, :ingredient => 'banana'}, template.parse([tok_a, tok_b]))
  end

  def test_scalar_measurement_ingredient_parser
    template = Onigiri::Template.new([:scalar, :measurement, :ingredient], :parse_scl_msr_ing)
    
    scl = Onigiri::Token.new("10")
    scl.add_tag(Onigiri::Scalar.new(10))

    ing = Onigiri::Token.new("banana")
    ing.add_tag(Onigiri::Ingredient.new('banana'))

    msr = Onigiri::Token.new("kilogram")
    msr.add_tag(Onigiri::Measurement.new('kilogram'))

    expected_result = {:ammount => 10, :ingredient => 'banana', :measurement => 'kilogram'}
    assert_equal expected_result, template.parse([scl, msr, ing])
  end
end