require "test/unit"

require_relative 'lambda_turing.rb'

class TestLambdaTuring < Test::Unit::TestCase

  def test_tape
    current_tape = TAPE[EMPTY][ZERO][EMPTY][ZERO]

    current_tape = TAPE_WRITE[current_tape][ONE]
    current_tape = TAPE_MOVE_HEAD_RIGHT[current_tape]

    current_tape = TAPE_WRITE[current_tape][TWO]
    current_tape = TAPE_MOVE_HEAD_RIGHT[current_tape]

    current_tape = TAPE_WRITE[current_tape][THREE]
    current_tape = TAPE_MOVE_HEAD_RIGHT[current_tape]

    assert_equal([1, 2, 3], 
                 to_array(TAPE_LEFT[current_tape]).map { |p| to_integer(p) })

    assert_equal(0, to_integer(TAPE_MIDDLE[current_tape]))


    assert_equal([], 
                 to_array(TAPE_RIGHT[current_tape]).map { |p| to_integer(p) })

 end

end
