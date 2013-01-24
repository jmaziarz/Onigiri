require 'helper'

class TestOnigiri < MiniTest::Unit::TestCase
  def setup
    
  end

  def test_normalized_text_has_no_punctuation
    text = "the, end."
    assert_equal "the end", Onigiri::Onigiri.normalize(text)
  end

  def test_normalizes_use_of_whole_after_number
    assert_equal "1 pumpkin", Onigiri::Onigiri.normalize("one whole pumpkin")
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

  def test_parsing_from_text_sclmsr_msr_ing
    Onigiri::Ingredient.set_ingredient 'cherry tomato'
    assert_equal result('cherry tomato', 10, 'pound'), Onigiri::Onigiri.parse("10 lbs of cherry tomato")
  end

  def test_parsing_from_text_including_ingredient_variation
    Onigiri::Ingredient.set_ingredient 'dijon mustard', 'dijjon'
    assert_equal(result('dijon mustard', 1, 'tablespoon'), Onigiri::Onigiri.parse("1 tbsp Dijjon mustard"))
  end

  def test_parsing_sclmsr_msr_ing
    assert_equal result('honey', 1.5, 'tablespoon'), Onigiri::Onigiri.parse("1 1/2 tbsp honey")
  end

  def test_parsing_multiple_ingredients_
    text = "1/2 cup each carrots, celery and onions"
    assert_equal result('carrot', 0.5, 'cup'),  Onigiri::Onigiri.parse(text)
  end

  def result(ingredient, ammount="", measurement="", modifier="")
     result = {  :ammount => ammount, 
                 :ingredient => ingredient,
                 :measurement => measurement, 
                 :modifier => modifier 
               }
  end
end