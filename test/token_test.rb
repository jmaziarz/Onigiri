class TestToken < MiniTest::Unit::TestCase

  def setup
    @token = Onigiri::Token.allocate 
  end

  def test_has_name
    @token.name = "flour"
    assert_equal "flour", @token.name
  end

  def test_has_tags
    @token.tags = [:scalar, :modifier]
    assert_equal([:scalar, :modifier], @token.tags)
  end

  def test_can_add_tags
    @token.add_tag :scalar
    assert @token.tags.include? :scalar
  end
end