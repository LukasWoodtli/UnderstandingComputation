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
  def test_rulebook
    rulebook = DPDARulebook.new([PDARule.new(1, '(', 2, '$', ['b', '$']),
                                  PDARule.new(2, '(', 2, 'b', ['b', 'b']),
                                  PDARule.new(2, ')', 2, 'b', []),
                                  PDARule.new(2, nil, 1, '$', ['$'])])

    configuration = PDAConfiguration.new(1, Stack.new(['$']))

    configuration = rulebook.next_configuration(configuration, '(')
    assert_equal(PDAConfiguration.new(2, Stack.new(['b', '$'])), configuration)

    configuration = rulebook.next_configuration(configuration, '(')
    assert_equal(PDAConfiguration.new(2, Stack.new(['b', 'b', '$'])), configuration)

    configuration = rulebook.next_configuration(configuration, ')')
    assert_equal(PDAConfiguration.new(2, Stack.new(['b', '$'])), configuration)
  end
end

