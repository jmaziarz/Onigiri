require 'helper'

class TestScalar < MiniTest::Unit::TestCase
  def setup
    
  end

  def test_adds_measurment_scalar_tag_to_token
    scl_tok = Onigiri::Token.new("150")  
    msr_tok = Onigiri::Token.new("lb")  
    Onigiri::Scalar.scan_for_measurement(scl_tok, msr_tok)
    tag = scl_tok.get_tag(Onigiri::ScalarMeasurement)
    assert_equal 150, tag.type 
  end
end