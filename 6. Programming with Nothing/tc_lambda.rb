require "test/unit"
require_relative 'lambda.rb'

class TestLambda < Test::Unit::TestCase
  def test_to_integer
    assert_equal(0, to_integer(ZERO))
    assert_equal(1, to_integer(ONE))
    assert_equal(3, to_integer(THREE))

    assert_equal(5, to_integer(FIVE))
    assert_equal(15, to_integer(FIFTEEN))
    assert_equal(100, to_integer(HUNDRED))
  end

  def test_to_boolean
    assert_equal(true, to_boolean(TRUE))
    assert_equal(false, to_boolean(FALSE))
  end

  def test_if
    assert_equal('happy', IF[TRUE]['happy']['sad'])
    assert_equal('sad', IF[FALSE]['happy']['sad'])
  end

  def test_if_zero
    assert(to_boolean(IS_ZERO[ZERO]))
    assert(!to_boolean(IS_ZERO[THREE]))
  end

  def test_pair
    my_pair = PAIR[THREE][FIVE]

    assert_equal(3, to_integer(LEFT[my_pair]))
    assert_equal(5, to_integer(RIGHT[my_pair]))
  end

  def test_increment
    assert_equal(1, to_integer(INCREMENT[ZERO]))
    assert_equal(2, to_integer(INCREMENT[ONE]))
    assert_equal(3, to_integer(INCREMENT[TWO]))
    assert_equal(5, to_integer(INCREMENT[INCREMENT[THREE]]))
  end

  def test_slide
    assert_equal(1, to_integer(RIGHT[SLIDE[PAIR[ZERO][ZERO]]]))
  end

  def test_decrement
    assert_equal(4, to_integer(DECREMENT[FIVE]))
    assert_equal(99, to_integer(DECREMENT[HUNDRED]))
  end


end
