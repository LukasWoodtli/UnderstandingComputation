require "test/unit" 
require_relative 'dfa.rb'

class TestRulebook < Test::Unit::TestCase
  def setup
  	 @rulebook = DFARulebook.new([
                 FARule.new(1, 'a', 2), FARule.new(1, 'b', 1),
                 FARule.new(2, 'a', 2), FARule.new(2, 'b', 3),
                 FARule.new(3, 'a', 3), FARule.new(3, 'b', 3)])
  end
  
  def test_rulebook
   assert_equal(2, @rulebook.next_state(1, 'a')) 
   assert_equal(1, @rulebook.next_state(1, 'b'))
   assert_equal(3, @rulebook.next_state(2, 'b'))
 end

  def test_DFA
  	assert(DFA.new(1, [1,3], @rulebook).accepting?)
  	assert(!DFA.new(1, [3], @rulebook).accepting?)
  end

  def test_DFA_chars
    dfa = DFA.new(1, [3], @rulebook)
    assert(!dfa.accepting?)
    
    dfa.read_character('b')
    assert(!dfa.accepting?)

    3.times do dfa.read_character('a') end
    assert(!dfa.accepting?)

    dfa.read_character('b')
    assert(dfa.accepting?)
  end

  def test_DFA_string
    dfa = DFA.new(1, [3], @rulebook)
    assert(!dfa.accepting?)

    dfa.read_string('baaab')
    assert(dfa.accepting?)
  end

  def test_DFADesign
    dfa_design = DFADesign.new(1, [3], @rulebook)
    assert(!dfa_design.accepts?('a'))
    assert(!dfa_design.accepts?('baa'))
    assert(dfa_design.accepts?('baba'))
  end
end
