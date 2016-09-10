require 'test/unit'

require 'set'

require_relative 'abstract_interpretation.rb'

class TestAI < Test::Unit::TestCase
  def test_multiply
    assert_equal("#<Sign positive>", (Sign::POSITIVE * Sign::POSITIVE).inspect)

    assert_equal("#<Sign zero>", (Sign::NEGATIVE * Sign::ZERO).inspect)

    assert_equal("#<Sign negative>", (Sign::POSITIVE * Sign::NEGATIVE).inspect)


    assert_equal(Sign::POSITIVE, (Sign::POSITIVE + Sign::NEGATIVE) * 
                                   Sign::ZERO + Sign::POSITIVE)
    
  end

  def test_sign_of_numeric
    assert_equal(Sign::POSITIVE, 6.sign)

    assert_equal(Sign::NEGATIVE, -9.sign)

    assert_equal(Sign::NEGATIVE, 6.sign * -9.sign)


    assert_equal((10 + 3).sign, (10.sign + 3.sign))
    assert_equal((-5 + 0).sign, (-5.sign + 0.sign))

    # !!!
    assert_not_equal((6 + -9).sign, (6.sign + -9.sign))
    assert_equal(Sign::NEGATIVE, (6 + -9).sign)
    assert_equal(Sign::UNKNOWN, 6.sign + -9.sign)


  end
    
  def test_calculate
    assert_equal(0, calculate(3, -5, 0))

    assert_equal(Sign::ZERO,
                 calculate(Sign::POSITIVE, Sign::NEGATIVE, Sign::ZERO))

    assert_equal((6 * -9).sign, (6.sign * -9.sign))
    assert_equal((100 * 0).sign, (100.sign * 0.sign))
    assert_equal(calculate(1, -2, -3).sign, calculate(1.sign, -2.sign, -3.sign))
  end

  def test_add
    assert_equal(Sign::POSITIVE, Sign::POSITIVE + Sign::POSITIVE)
    assert_equal(Sign::NEGATIVE, Sign::NEGATIVE + Sign::ZERO)
    assert_equal(Sign::UNKNOWN, Sign::NEGATIVE + Sign::POSITIVE)

    assert_equal(Sign::UNKNOWN, Sign::POSITIVE + Sign::UNKNOWN)
    assert_equal(Sign::UNKNOWN, Sign::UNKNOWN + Sign::ZERO)
    assert_equal(Sign::UNKNOWN,  Sign::POSITIVE + Sign::NEGATIVE + Sign::NEGATIVE)
  end

  def test_fits_inside
    assert(Sign::POSITIVE <= Sign::POSITIVE)
    assert(Sign::POSITIVE <= Sign::UNKNOWN)
    assert(!(Sign::POSITIVE <= Sign::NEGATIVE))

    assert((6 * -9).sign <= (6.sign * -9.sign))
    assert((-5 * 0).sign <= (-5.sign * 0.sign))
    assert((6 + -9).sign <= (6.sign + -9.sign))
  end

  def test_sum_of_squares
    inputs = Sign::NEGATIVE, Sign::ZERO, Sign::POSITIVE
    outputs = inputs.product(inputs).map { |x, y| sum_of_squares(x, y) }

    assert_equal(Set[Sign::ZERO, Sign::POSITIVE], outputs.uniq.to_set)

  end
end

