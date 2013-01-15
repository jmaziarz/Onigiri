require 'helper'

class TestScalar < MiniTest::Unit::TestCase
  def setup
    
  end

  def test_adds_scalar_tag_to_token
    token = Onigiri::Token.new("150")  
    Onigiri::Scalar.scan_for_scalar(token)
    assert token.tags.include?(:scalar)
  end
end