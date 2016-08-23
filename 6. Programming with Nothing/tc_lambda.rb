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

  def test_numerical_operations
    assert_equal(4, to_integer(ADD[ONE][THREE]))
    assert_equal(13, to_integer(SUBTRACT[FIFTEEN][TWO]))
    assert_equal(15, to_integer(MULTIPLY[THREE][FIVE]))
    assert_equal(8, to_integer(POWER[TWO][THREE]))
  end

  def test_is_less_or_equal
    assert(to_boolean(IS_LESS_OR_EQUAL[ONE][TWO]))
    assert(to_boolean(IS_LESS_OR_EQUAL[TWO][TWO]))
    assert(!to_boolean(IS_LESS_OR_EQUAL[THREE][TWO]))
  end

  def test_mod
    assert_equal(1, to_integer(MOD[THREE][TWO]))
    assert_equal(2, to_integer(MOD[POWER[THREE][THREE]][ADD[THREE][TWO]]))
  end

  def test_mod_alt
    assert_equal(1, to_integer(MOD_ALT[THREE][TWO]))
    assert_equal(2, to_integer(MOD_ALT[POWER[THREE][THREE]][ADD[THREE][TWO]]))
  end

  def test_list
    my_list = UNSHIFT[UNSHIFT[UNSHIFT[EMPTY][THREE]][TWO]][ONE]

    assert_equal(1, to_integer(FIRST[my_list]))
    assert_equal(2, to_integer(FIRST[REST[my_list]]))
    assert_equal(3, to_integer(FIRST[REST[REST[my_list]]]))

    assert(!to_boolean(IS_EMPTY[my_list]))
    assert(to_boolean(IS_EMPTY[EMPTY]))
  end

  def test_range
    my_range = RANGE[ONE][FIVE]
    assert_equal([1,2,3,4,5], to_array(my_range).map{ |p| to_integer(p)})
  end

  def test_range_alt
  #  my_range = RANGE_ALT[ONE][FIVE]
  #  assert_equal([1,2,3,4,5], to_array(my_range).map{ |p| to_integer(p)})
  end

  def test_fold
    assert_equal(15, to_integer(FOLD[RANGE[ONE][FIVE]][ZERO][ADD]))
    assert_equal(120, to_integer(FOLD[RANGE[ONE][FIVE]][ONE][MULTIPLY]))
  end

  def test_map
    my_list = MAP[RANGE[ONE][FIVE]][INCREMENT]
    assert_equal([2, 3, 4, 5, 6], to_array(my_list).map { |p| to_integer(p)})
  end

  def test_strings
    assert_equal('z', to_char(ZED))
    assert_equal('FizzBuzz', to_string(FIZZBUZZ))
    
    assert_equal("5", to_string(TO_DIGITS[FIVE]))
    assert_equal("125", to_string(TO_DIGITS[POWER[FIVE][THREE]]))
  end

  def test_to_digits
    assert_equal([5], to_array(TO_DIGITS[FIVE]).map { |p| to_integer(p)})
    assert_equal([1, 2, 5], to_array(TO_DIGITS[POWER[FIVE][THREE]]).map { |p| to_integer(p)})
  end

  def test_fizz_buzz
    solution = MAP[RANGE[ONE][HUNDRED]][ -> n {
                 IF[IS_ZERO[MOD[n][FIFTEEN]]][
                   FIZZBUZZ
                 ][IF[IS_ZERO[MOD[n][THREE]]][
                   FIZZ
                 ][IF[IS_ZERO[MOD[n][FIVE]]][
                   BUZZ
                 ][
                   TO_DIGITS[n]
                 ]]]
                 }]
    assert_equal(ruby_fizz_buzz, to_array(solution).map {|p| to_string(p)})
  end

  def ruby_fizz_buzz
    (1..100).map { |n| 
      if(n % 15).zero?
        'FizzBuzz'
      elsif(n % 3).zero?
        'Fizz'
      elsif(n % 5).zero?
        'Buzz'
      else
        n.to_s
      end }
  end

  def test_zeros
    assert_equal(0, to_integer(FIRST[ZEROS]))
    assert_equal(0, to_integer(FIRST[REST[ZEROS]]))
    assert_equal(0, to_integer(FIRST[REST[REST[REST[REST[REST[ZEROS]]]]]]))

    assert_equal([0], to_array(ZEROS, 1).map { |p| to_integer(p)})
    assert_equal([0, 0, 0, 0, 0], to_array(ZEROS, 5).map { |p| to_integer(p)})
    assert_equal([0, 0, 0, 0, 0, 0, 0, 0, 0, 0], to_array(ZEROS, 10).map { |p| to_integer(p)})
  end

  def test_upwards
    assert_equal([0, 1, 2, 3, 4], to_array(UPWARDS_OF[ZERO], 5).map { |p| to_integer(p)})
    assert_equal([15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34], 
                 to_array(UPWARDS_OF[FIFTEEN], 20).map { |p| to_integer(p)})
  end

  def test_multiples_of
    assert_equal([2, 4, 6, 8, 10, 12, 14, 16, 18, 20], to_array(MULTIPLES_OF[TWO], 10).map { |p| to_integer(p)})
    assert_equal([5, 10, 15, 20, 25, 30, 35, 40, 45, 50], to_array(MULTIPLES_OF[FIVE], 10).map { |p| to_integer(p)})
  end

  def test_mltiply_streams
    assert_equal([3, 12, 27, 48, 75, 108, 147, 192, 243, 300],
                 to_array(MULTIPLY_STREAMS[UPWARDS_OF[ONE]][MULTIPLES_OF[THREE]], 10).map { |p| to_integer(p)})
  end

end
