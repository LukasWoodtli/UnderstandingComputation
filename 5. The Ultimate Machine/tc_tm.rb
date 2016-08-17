require "test/unit"
require_relative 'tm.rb'

class TestTm < Test::Unit::TestCase

  def test_tape
    tape = Tape.new(['1', '0', '1'], '1', [], '_')

    assert_equal('1', tape.middle)
    assert_equal("#<Tape 101(1)>", tape.inspect)

    
    assert_equal("#<Tape 10(1)1>", tape.move_head_left.inspect)

    assert_equal("#<Tape 101(0)>", tape.write(0).inspect)

    assert_equal("#<Tape 1011(_)>", tape.move_head_right.inspect)
    assert_equal("#<Tape 1011(0)>", tape.move_head_right.write('0').inspect)
  end
end

