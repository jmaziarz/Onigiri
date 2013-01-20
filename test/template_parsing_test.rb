require 'helper'

class TestTemplateParsing < MiniTest::Unit::TestCase

  def setup

  end

  def test_scalar_ingredient_parser 
    template = Onigiri::Template.new([:scalar, :ingredient], :parse_scalar_ingredient)

    tok_a = Onigiri::Token.new("10")
    tok_a.add_tag(Onigiri::Scalar.new(10))

    tok_b = Onigiri::Token.new("banana")
    tok_b.add_tag(Onigiri::Ingredient.new('banana'))

    assert_equal({:ammount => 10, :ingredient => 'banana'}, template.parse([tok_a, tok_b]))
  end

  def test_sclmsr_msr_ing
    template = Onigiri::Template.new([:scalar_measurment, :measurement, :ingredient], :parse_sclmsr_msr_ing)
    
    scl = Onigiri::Token.new("10")
    scl.add_tag(Onigiri::ScalarMeasurement.new(10))

    ing = Onigiri::Token.new("banana")
    ing.add_tag(Onigiri::Ingredient.new('banana'))

    msr = Onigiri::Token.new("kilogram")
    msr.add_tag(Onigiri::Measurement.new('kilogram'))

    expected_result = {:ammount => 10, :ingredient => 'banana', :measurement => 'kilogram'}
    assert_equal expected_result, template.parse([scl, msr, ing])
  end
  
  #3 tbsp unsweetened applesauce
  def test_sclmsr_msr_mod_ing
    template = Onigiri::Template.new([:scalar, :measurement, :modifier, :ingredient], :parse_sclmsr_msr_mod_ing)
    
    scl = Onigiri::Token.new("10")
    scl.add_tag(Onigiri::ScalarMeasurement.new(10))

    mod = Onigiri::Token.new("unsweetned")
    mod.add_tag(Onigiri::Modifier.new("unsweetned"))
       
    ing = Onigiri::Token.new("banana")
    ing.add_tag(Onigiri::Ingredient.new('banana'))

    msr = Onigiri::Token.new("kilogram")
    msr.add_tag(Onigiri::Measurement.new('kilogram'))

    expected_result = {:ammount => 10, :ingredient => 'banana', :modifier => 'unsweetned', :measurement => 'kilogram'}
    assert_equal expected_result, template.parse([scl, msr, mod, ing])
  end

  #15 g  goat cheese, crumbled
  def test_sclmsr_msr_ing_mod
    template = Onigiri::Template.new([:scalar, :measurement, :ingredient, :modifier], :parse_sclmsr_msr_ing_mod)
    
    scl = Onigiri::Token.new("10")
    scl.add_tag(Onigiri::ScalarMeasurement.new(10))

    mod = Onigiri::Token.new("unsweetned")
    mod.add_tag(Onigiri::Modifier.new("unsweetned"))
       
    ing = Onigiri::Token.new("banana")
    ing.add_tag(Onigiri::Ingredient.new('banana'))

    msr = Onigiri::Token.new("kilogram")
    msr.add_tag(Onigiri::Measurement.new('kilogram'))

    expected_result = {:ammount => 10, :ingredient => 'banana', :modifier => 'unsweetned', :measurement => 'kilogram'}
    assert_equal expected_result, template.parse([scl, msr, ing, mod])
  end

  #leaves roughly chopped
  def test_ing_mod
    template = Onigiri::Template.new([:ingredient, :modifier], :parse_ing_mod)
    
    mod = Onigiri::Token.new("unsweetned")
    mod.add_tag(Onigiri::Modifier.new("unsweetned"))
       
    ing = Onigiri::Token.new("banana")
    ing.add_tag(Onigiri::Ingredient.new('banana'))

    expected_result = {:ammount => 1, :ingredient => 'banana', :modifier => 'unsweetned'}
    assert_equal expected_result, template.parse([ing, mod])
  end

  def test_mod_ing
    template = Onigiri::Template.new([:modifier, :ingredient], :parse_mod_ing)
    
    mod = Onigiri::Token.new("unsweetned")
    mod.add_tag(Onigiri::Modifier.new("unsweetned"))
       
    ing = Onigiri::Token.new("banana")
    ing.add_tag(Onigiri::Ingredient.new('banana'))

    expected_result = {:ammount => 1, :ingredient => 'banana', :modifier => 'unsweetned'}
    assert_equal expected_result, template.parse([mod, ing])
  end

  
end

