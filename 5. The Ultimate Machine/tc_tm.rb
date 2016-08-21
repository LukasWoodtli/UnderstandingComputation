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

class StringRecoginzingTM < Test::Unit::TestCase
  def test_tm
    rulebook = DTMRulebook.new([
                    # state 1: scan right looking for 'a'
                    TMRule.new(1, 'X', 1, 'X', :right), # skip 'X'
                    TMRule.new(1, 'a', 2, 'X', :right), # cross out 'a' go to state 2
                    TMRule.new(1, '_', 6, '_', :left), # find blank, go to state 6 (accept)

                    # state 2: scan right looking for 'b'
                    TMRule.new(2, 'a', 2, 'a', :right), # skip 'a'
                    TMRule.new(2, 'X', 2, 'X', :right), # skip 'X'
                    TMRule.new(2, 'b', 3, 'X', :right), # cross out b, go to state 3
                    
                    # state 3: scan right looking for 'c'
                    TMRule.new(3, 'b', 3, 'b', :right), # skip 'b'
                    TMRule.new(3, 'X', 3, 'X', :right), # skip 'X'
                    TMRule.new(3, 'c', 4, 'X', :right), # cross out 'c', go to state 4

                    # state 4: scan right looking for end of string
                    TMRule.new(4, 'c', 4, 'c', :right), # skip 'c'
                    TMRule.new(4, '_', 5, '_', :left), # find blank, go to state 5

                    # state 5: scan left looking for beginning of string
                    TMRule.new(5, 'a', 5, 'a', :left), # skip 'a'
                    TMRule.new(5, 'b', 5, 'b', :left), # skip 'b'
                    TMRule.new(5, 'c', 5, 'c', :left), # skip 'c'
                    TMRule.new(5, 'X', 5, 'X', :left), # skip 'X'
                    TMRule.new(5, '_', 1, '_', :right) # find blank, go to state 1
                    ])

    tape = Tape.new([], 'a', ['a', 'a', 'b', 'b', 'b', 'c', 'c', 'c'], '_')
    dtm = DTM.new(TMConfiguration.new(1, tape), [6], rulebook)

    10.times {dtm.step}
    assert_equal(TMConfiguration.new(5, Tape.new(['X', 'a', 'a', 'X', 'b', 'b', 'X', 'c'], 'c', ['_'], '_')), dtm.current_configuration)

    25.times {dtm.step}
    assert_equal(TMConfiguration.new(5, Tape.new(['_', 'X', 'X', 'a'], 'X', ['X', 'b', 'X', 'X', 'c', '_'], '_')), dtm.current_configuration)

    dtm.run
    assert_equal(TMConfiguration.new(6, Tape.new(['_', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'], 'X', ['_'], '_')), dtm.current_configuration)


  end
end
