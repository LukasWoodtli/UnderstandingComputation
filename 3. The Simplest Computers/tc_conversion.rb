require "test/unit"

require_relative 'nfa.rb'
require_relative 'conversion.rb'

class TestConversion < Test::Unit::TestCase

  def setup
    @rulebook = NFARulebook.new([FARule.new(1, 'a', 1), FARule.new(1, 'a', 2),
                                FARule.new(1, nil, 2), FARule.new(2, 'b', 3),
                                FARule.new(3, 'b', 1), FARule.new(3, nil, 2)])

    @nfa_design = NFADesign.new(1, [3], @rulebook)
  end
  
  def test_to_nfa
    

    assert_equal(Set[1, 2], @nfa_design.to_nfa.current_states)
    assert_equal(Set[2], @nfa_design.to_nfa(Set[2]).current_states)
    assert_equal(Set[2, 3], @nfa_design.to_nfa(Set[3]).current_states)

    nfa = @nfa_design.to_nfa(Set[2, 3])
    nfa.read_character('b')
    assert_equal(Set[1, 2, 3], nfa.current_states)

  end

  def test_simulation
    simulation = NFASimulation.new(@nfa_design)
    
    assert_equal(Set[1, 2], simulation.next_state(Set[1, 2], 'a'))
    assert_equal(Set[2, 3], simulation.next_state(Set[1, 2], 'b'))
    assert_equal(Set[1, 2, 3], simulation.next_state(Set[2, 3], 'b'))
    assert_equal(Set[1, 2, 3], simulation.next_state(Set[1, 2, 3], 'b'))
    assert_equal(Set[1, 2], simulation.next_state(Set[1, 2, 3], 'a'))
  end
  
  def test_alphabet
    assert_equal(["a", "b"], @rulebook.alphabet)
  end 
end