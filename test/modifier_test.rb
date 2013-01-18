require 'helper'

class TestModifier < MiniTest::Unit::TestCase
  def test_sets_variations_with_normalized_measurment
    Onigiri::Modifier.set_modifier 'finely chopped', 'finely chop'
    assert_equal 'finely chopped', Onigiri::Modifier.modifiers['finely chop']
  end

  def test_normalizes_multi_word_measurements_with_dashes
    Onigiri::Modifier.set_modifier 'finely chopped'
    assert_equal 'finely_chopped', Onigiri::Modifier.normalize('finely chopped')
  end

  def test_tags_token_with_single_word_name
    Onigiri::Modifier.set_modifier 'chopped'
    token = Onigiri::Token.new("chopped")
    Onigiri::Modifier.scan_for_modifier(token)
    assert_equal 'chopped', token.get_tag(Onigiri::Modifier).type
  end

  def test_tags_token_with_multi_word_name
    Onigiri::Modifier.set_modifier 'chopped finely'
    token = Onigiri::Token.new("chopped_finely")
    Onigiri::Modifier.scan_for_modifier(token)
    assert_equal 'chopped finely', token.get_tag(Onigiri::Modifier).type
  end
end