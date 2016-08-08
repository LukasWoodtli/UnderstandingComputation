require "test/unit"
require_relative 'pda.rb'

class TestPda < Test::Unit::TestCase
  def test_stack
    stack = Stack.new(['a', 'b', 'c', 'd', 'e'])

    assert_equal('a', stack.top)

    assert_equal("c", stack.pop.pop.top)

    assert_equal("y", stack.push('x').push('y').top)

    assert_equal("x", stack.push('x').push('y').pop.top)
  end

  def test_rule
    rule = PDARule.new(1, '(', 2, '$', ['b', '$'])
    configuration = PDAConfiguration.new(1, Stack.new(['$']))

    assert(rule.applies_to?(configuration, '('))
  end
end


class TestDpda < Test::Unit::TestCase

  def setup
    @rulebook = DPDARulebook.new([PDARule.new(1, '(', 2, '$', ['b', '$']),
                                  PDARule.new(2, '(', 2, 'b', ['b', 'b']),
                                  PDARule.new(2, ')', 2, 'b', []),
                                  PDARule.new(2, nil, 1, '$', ['$'])])
  end

  def test_rulebook
    configuration = PDAConfiguration.new(1, Stack.new(['$']))

    configuration = @rulebook.next_configuration(configuration, '(')
    assert_equal(PDAConfiguration.new(2, Stack.new(['b', '$'])), configuration)

    configuration = @rulebook.next_configuration(configuration, '(')
    assert_equal(PDAConfiguration.new(2, Stack.new(['b', 'b', '$'])), configuration)

    configuration = @rulebook.next_configuration(configuration, ')')
    assert_equal(PDAConfiguration.new(2, Stack.new(['b', '$'])), configuration)
  end

  def test_dpda1
    dpda = DPDA.new(PDAConfiguration.new(1, Stack.new(['$'])), [1], @rulebook)

    assert(dpda.accepting?)

    dpda.read_string('(()')
    assert(!dpda.accepting?)

    assert_equal(PDAConfiguration.new(2, Stack.new(['b', '$'])),
                 dpda.current_configuration)
  end

  def test_dpda2
    dpda = DPDA.new(PDAConfiguration.new(1, Stack.new(['$'])), [1], @rulebook)

    dpda.read_string('(()(')
    assert(!dpda.accepting?)

    assert_equal(PDAConfiguration.new(2, Stack.new(['b', 'b', '$'])),
                 dpda.current_configuration)

    dpda.read_string('))()')
    assert(dpda.accepting?)

    assert_equal(PDAConfiguration.new(1, Stack.new(['$'])),
                 dpda.current_configuration)



  end

  def test_free_moves
    configuration = PDAConfiguration.new(2, Stack.new(['$']))

    assert_equal(PDAConfiguration.new(1, Stack.new(['$'])),
                 @rulebook.follow_free_moves(configuration))
  end

  def test_dpda_design
    dpda_design = DPDADesign.new(1, '$', [1], @rulebook)

    assert(dpda_design.accepts?('(((((((((())))))))))'))
    assert(dpda_design.accepts?('()(())((()))(()(()))'))
    assert(!dpda_design.accepts?('(()(()(()()(()()))()'))
    assert(!dpda_design.accepts?('())'))
  end

  def test_stuck
    dpda = DPDA.new(PDAConfiguration.new(1, Stack.new(['$'])), [1], @rulebook)

    dpda.read_string('())')

    assert(!dpda.accepting?)
    assert(dpda.stuck?)
  end
end

class TestEqualNumberCharacters < Test::Unit::TestCase
  def test_equal_num_chars
    rulebook = DPDARulebook.new([
      PDARule.new(1, 'a', 2, '$', ['a', '$']),
      PDARule.new(1, 'b', 2, '$', ['b', '$']),
      PDARule.new(2, 'a', 2, 'a', ['a', 'a']),
      PDARule.new(2, 'b', 2, 'b', ['b', 'b']),
      PDARule.new(2, 'a', 2, 'b', []),
      PDARule.new(2, 'b', 2, 'a', []),
      PDARule.new(2, nil, 1, '$', ['$'])
    ])

    dpda_design = DPDADesign.new(1, '$', [1], rulebook)

    assert(dpda_design.accepts?('ababab'))
    assert(dpda_design.accepts?('bbbaaaab'))
    assert(!dpda_design.accepts?('baa'))
  end

end


class TestPalindromes < Test::Unit::TestCase
  def setup
    @rulebook = DPDARulebook.new([PDARule.new(1, 'a', 1, '$', ['a', '$']),
                                  PDARule.new(1, 'a', 1, 'a', ['a', 'a']),
                                  PDARule.new(1, 'a', 1, 'b', ['a', 'b']),
                                  PDARule.new(1, 'b', 1, '$', ['b', '$']),
                                  PDARule.new(1, 'b', 1, 'a', ['b', 'a']),
                                  PDARule.new(1, 'b', 1, 'b', ['b', 'b']),
                                  PDARule.new(1, 'm', 2, '$', ['$']),
                                  PDARule.new(1, 'm', 2, 'a', ['a']),
                                  PDARule.new(1, 'm', 2, 'b', ['b']),
                                  PDARule.new(2, 'a', 2, 'a', []),
                                  PDARule.new(2, 'b', 2, 'b', []),
                                  PDARule.new(2, nil, 3, '$', ['$'])])
  end

  def test_palindrome
    dpda_design = DPDADesign.new(1, '$', [3], @rulebook)

    assert(dpda_design.accepts?('abmba'))

    assert(dpda_design.accepts?('babbamabbab'))

    assert(!dpda_design.accepts?('abmb'))

    assert(!dpda_design.accepts?('baambaa'))

  end
                                  
end

