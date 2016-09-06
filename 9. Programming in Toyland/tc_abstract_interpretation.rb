require 'test/unit'

require_relative 'abstract_interpretation.rb'

class TestAI < Test::Unit::TestCase
  def test_multiply
    assert_equal("#<Sign positive>", (Sign::POSITIVE * Sign::POSITIVE).inspect)

    assert_equal("#<Sign zero>", (Sign::NEGATIVE * Sign::ZERO).inspect)

    assert_equal("#<Sign negative>", (Sign::POSITIVE * Sign::NEGATIVE).inspect)
  end

  def test_sign_of_numeric
    assert_equal(Sign::POSITIVE, 6.sign)

    assert_equal(Sign::NEGATIVE, -9.sign)

    assert_equal(Sign::NEGATIVE, 6.sign * -9.sign)
  end
    
end

