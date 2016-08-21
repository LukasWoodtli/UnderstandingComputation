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


class TestRule < Test::Unit::TestCase
  
  def setup
    @rule = TMRule.new(1, '0', 2, '1', :right)
  end

  def test_rule
    assert(@rule.applies_to?(TMConfiguration.new(1, Tape.new([], '0', [], '_'))))

    assert(!@rule.applies_to?(TMConfiguration.new(1, Tape.new([], '1', [], '_'))))

    assert(!@rule.applies_to?(TMConfiguration.new(2, Tape.new([], '0', [], '_'))))

  end

  def test_follow
    assert_equal(TMConfiguration.new(2, Tape.new(['1'], '_', [], '_')),
                 @rule.follow(TMConfiguration.new(1, Tape.new([], '0', [], '_'))))
  end

end

class TestTm < Test::Unit::TestCase
  def setup
    @rulebook = DTMRulebook.new([TMRule.new(1, '0', 2, '1', :right),
                                 TMRule.new(1, '1', 1, '0', :left),
                                 TMRule.new(1, '_', 2, '1', :right),
                                 TMRule.new(2, '0', 2, '0', :right),
                                 TMRule.new(2, '1', 2, '1', :right),
                                 TMRule.new(2, '_', 3, '_', :left),
                                ])
     @tape = Tape.new(['1', '0', '1'], '1', [], '_')
  end

  def test_configuration

     configuration = TMConfiguration.new(1, @tape)
    
     configuration = @rulebook.next_configuration(configuration)
     assert_equal(TMConfiguration.new(1, Tape.new(['1', '0'], '1', ['0'], '_')), configuration)

     configuration = @rulebook.next_configuration(configuration)
     assert_equal(TMConfiguration.new(1, Tape.new(['1'], '0', ['0', '0'], '_')), configuration)

     configuration = @rulebook.next_configuration(configuration)
     assert_equal(TMConfiguration.new(2, Tape.new(['1', '1'], '0', ['0'], '_')), configuration)

  end

  def test_dtm
    dtm = DTM.new(TMConfiguration.new(1, @tape), [3], @rulebook)

    assert(!dtm.accepting?)

    dtm.step
    assert_equal(TMConfiguration.new(1, Tape.new(['1', '0'], '1', ['0'], '_')), dtm.current_configuration)
    assert(!dtm.accepting?)

    dtm.run
    assert_equal(TMConfiguration.new(3, Tape.new(['1', '1', '0'], '0', ['_'], '_')), dtm.current_configuration)
    assert(dtm.accepting?)
  end

  def test_stuck
    tape = Tape.new(['1', '2', '1'], '1', [], '_')
    dtm = DTM.new(TMConfiguration.new(1, tape), [3], @rulebook)

    dtm.run

    assert_equal(TMConfiguration.new(1, Tape.new(['1'], '2', ['0', '0'], '_')), dtm.current_configuration)
    
    assert(!dtm.accepting?)

    assert(dtm.stuck?)
  end

end
