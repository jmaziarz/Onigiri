# encoding: UTF-8 
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

  def test_tricky_strings
    tricky_strings = [["3 ounces (85 grams) semisweet or good white chocolate*, coarsely chopped", result('white chocolate', 3.0, 'ounce', 'chopped')],
                      ["1/4 to 1/2 cup maple syrup", result('maple syrup', 0.25, 'cup')],
                      ["1/4 cup olive oil", result('olive oil', 0.25, 'cup')],
                      ["1 1/2 cups packed (285 grams) dark-brown sugar", result('dark-brown sugar', 1.5, 'cup')],
                      ['1 cup stock (your choice; Julia recommends beef) or cream (I used stock; it doesn’t *need* cream)', result('stock', 1.0, 'cup')]
                    ]
    tricky_strings.each do |string, expected_result|
      assert_equal expected_result, Onigiri::Onigiri.parse(string), string
    end
  end

  def test_calculates_all_tag_combinations_for_debugging
    tok_a = Onigiri::Token.new("a")
    tok_b = Onigiri::Token.new("b")

    tag_a = Onigiri::ScalarMeasurement.new(10)
    tag_b = Onigiri::Ingredient.new("pork")
    tag_c = Onigiri::Modifier.new("sliced")

    tok_a.add_tag tag_a 
    tok_a.add_tag tag_b
    tok_b.add_tag tag_c

    tokens = [tok_a, tok_b]

    assert_equal ["ScalarMeasurement Modifier", "Ingredient Modifier"], Onigiri::Onigiri.tag_combinations_for(tokens)
  end

  #items to test
  #1/4 to 1/3 cup (60 to 80 ml) maple syrup (less for less sweetness, of course)
  #1/4 cup olive oil => why is it extracting only oil and not olive oil 
  #1.0 - large -  - clove <==> 1 large clove garlic, thinly sliced => confusing clove spice with measurment clove
  #1/2 teaspoon red pepper flakes, or more or less to taste => keeps matching red pepper and not flakes
  #Juice of one lemon => get juice of extracted as modifier
  #5 to 6 cups low-sodium chicken or vegetable broth => should extract "chicken or vegetable borth" and not "chicken"
  def result(ingredient, ammount="", measurement="", modifier="", status=:success)
     result = {  :ammount => ammount, 
                 :ingredient => ingredient,
                 :measurement => measurement, 
                 :modifier => modifier, 
                 :status   => status
               }
  end
end