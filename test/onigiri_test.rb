# encoding: UTF-8 
require 'helper'

class TestOnigiri < MiniTest::Unit::TestCase
  def setup
    
  end

  def test_normalized_text_has_no_punctuation
    text = %q{the, "end".}
    assert_equal "the end", Onigiri::Onigiri.normalize(text)
  end

  def test_normalizes_use_of_whole_after_number
    assert_equal "1 pumpkin", Onigiri::Onigiri.normalize("one whole pumpkin")
  end 

  def test_normalizes_hypen_with_space_for_hyphenated_words
    assert_equal "space me out", Onigiri::Onigiri.normalize("space-me-out")
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
    result = Onigiri::Onigiri.parse("10 lbs of cherry tomato")
    assert_equal result_hash('cherry tomato', 10.0, 'lb', ''), result.parsings
  end

  def test_parsing_from_text_including_ingredient_variation
    assert_equal(result_hash('dijon mustard', 1, 'tbsp'), Onigiri::Onigiri.parse("1 tbsp Dijjon mustard").parsings)
  end

  def test_parsing_sclmsr_msr_ing
    assert_equal result_hash('honey', 1.5, 'tbsp'), Onigiri::Onigiri.parse("1 1/2 tbsp honey").parsings
  end

  def test_parsing_multiple_ingredients
    r = Onigiri::Onigiri.parse("1/2 cup each carrots, celery and onions")
    assert_equal result_hash('carrot', 0.5, 'cup', ''), r.parsings
  end

  def test_this
    str = "1 12-ounce jar crunchy peanut butter"
    exp = result_hash('peanut butter', 1.0, '12 oz jar')
    act = Onigiri::Onigiri.parse(str, :debug => true).parsings
    assert_equal(exp, act)
  end

  
  def test_tricky_strings
    tricky_strings = [
                      ["1 1/2 teaspoons pure vanilla extract ", result_hash('vanilla extract', 1.5, 'tsp', '')],
                      ["Zest of 1 large lime ", result_hash('lime', 1.0, 'large', '')],
                      ["15 ounce can artichoke hearts, chopped", result_hash("artichoke heart", 1.0, '15 oz can', 'chopped')],
                      ["4 hamburger buns", result_hash('hamburger bun', 4.0)],
                      ["1-2 jalapeno chiles, seeded, minced", result_hash('jalapeno chile', 1.0, '', 'seeded, minced')],
                      ["1 12-ounce jar crunchy peanut butter", result_hash('peanut butter', 1.0, '12 oz jar')],
                      ["2 full sized (3.17oz) dark chocolate bars", result_hash('dark chocolate', 2.0, 'bar')],
                      ["zest of one lemon", result_hash('lemon', 1.0, '', 'zest')],
                      ["Oil for greasing the jars", result_hash('oil', 1.0)],
                      ["3 ounces (85 grams) semisweet or good white chocolate*, coarsely chopped", result_hash('white chocolate', 3.0, 'oz', 'chopped')],
                      ["1/4 to 1/2 cup maple syrup", result_hash('maple syrup', 0.25, 'cup')],
                      ["1/4 cup olive oil", result_hash('olive oil', 0.25, 'cup')],
                      ["1 1/2 cups packed (285 grams) dark-brown sugar", result_hash('dark-brown sugar', 1.5, 'cup')],
                      ['1 cup stock (your choice; Julia recommends beef) or cream (I used stock; it doesn’t *need* cream)', result_hash('stock', 1.0, 'cup')]
                    ]
    tricky_strings.each do |string, expected_result|
      actual_result = Onigiri::Onigiri.parse(string, :debug => false).parsings
      assert_equal expected_result, actual_result, string
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

  def result_hash(ingredient, ammount="", measurement="", modifier="")
     result = {  :ammount => ammount, 
                 :ingredient => ingredient,
                 :measurement => measurement, 
                 :modifier => modifier
               }
  end
end