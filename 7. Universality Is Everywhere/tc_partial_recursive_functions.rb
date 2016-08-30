require "test/unit"

require_relative 'partial_recursive_functions.rb'

class TestLambdaPartialRecursiveFunctions < Test::Unit::TestCase

  def test_zero_increment
    assert_equal(0, zero)
    assert_equal(1, increment(zero))
    assert_equal(2, increment(increment(zero)))
  end

  def two
    increment(increment(zero))
  end

  def three
    increment(two)
  end

  def add_three(x)
    increment(increment(increment(x)))
  end

  def test_add_three
    assert_equal(5, add_three(two))
  end

  # impelement addition

  def add_zero_to_x(x)
    x
  end

  def increment_easier_result(x, easier_y, easier_result)
    increment(easier_result)
  end

  def add(x, y)
    recurse(:add_zero_to_x, :increment_easier_result, x, y)
  end

  def test_add
    assert_equal(5, add(two, three))
  end

  # implement multiplication

  def multiply_x_by_zero(x)
    zero
  end

  def add_x_to_easier_result(x, easier_y, easier_result)
    add(x, easier_result)
  end

  def multiply(x, y)
    recurse(:multiply_x_by_zero, :add_x_to_easier_result, x, y)
  end

  # implement decrement

  def easier_x(easier_x, easier_result)
    easier_x
  end

  def decrement(x)
    recurse(:zero, :easier_x, x)
  end

  # implement subtract

  def subtract_zero_from_x(x)
    x
  end

  def decrement_easier_result(x, easier_y, easier_result)
    decrement(easier_result)
  end

  def subtract(x, y)
    recurse(:subtract_zero_from_x, :decrement_easier_result, x, y)
  end

  def test_multiply
    assert_equal(6, multiply(two, three))
  end

  def six
    multiply(two, three)
  end

  def test_decrement
    assert_equal(5, decrement(six))
  end

  def test_subtract
    assert_equal(4, subtract(six, two))

    assert_equal(0, subtract(two, six))
  end

  # implement divide

  def divide(x, y)
    minimize { |n| subtract(increment(x), multiply(y, increment(n))) }
  end

  def ten
    increment(multiply(three, three))
  end

  def test_divide
    assert_equal(3, divide(six, two))

    assert_equal(3, divide(ten, three))

    # this loops forever (stack level too deep)
    # divide(six, zero)
  end
end
