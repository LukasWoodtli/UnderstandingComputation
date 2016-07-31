require "test/unit"
require_relative 'nfa.rb'

class TestRulebook < Test::Unit::TestCase

  def setup
        @rulebook = NFARulebook.new([FARule.new(1, 'a', 1), FARule.new(1, 'b', 1),
                                FARule.new(1, 'b', 2),
                                FARule.new(2, 'a', 3), FARule.new(2, 'b', 3),
                                FARule.new(3, 'a', 4), FARule.new(3, 'b', 4)
                                ])
  end

  def test_NFA_rulebook
    assert_equal(@rulebook.next_states(Set[1], 'b'), Set.new([1, 2]))
    assert_equal(@rulebook.next_states(Set[1, 2], 'a'), Set.new([1, 3]))
    assert_equal(@rulebook.next_states(Set[1, 3], 'b'), Set.new([1, 2, 4]))
  end

  def test_NFA
    assert_equal(NFA.new(Set[1], [4], @rulebook).accepting?, false)
    
    assert_equal(NFA.new(Set[1, 2, 4], [4], @rulebook).accepting?, true)
  end

  def test_read_character
    nfa = NFA.new(Set[1], [4], @rulebook)
    assert(!nfa.accepting?)
    
    nfa.read_character('b')
    assert(!nfa.accepting?)

    nfa.read_character('a')
    assert(!nfa.accepting?)

    nfa.read_character('b')
    assert(nfa.accepting?)
  end

  def test_read_string
    nfa = NFA.new(Set[1], [4], @rulebook)
    assert(!nfa.accepting?)

    nfa.read_string('bbbbb')
    assert(nfa.accepting?)
  end

  def test_NFADesign
    nfa_design = NFADesign.new(1, [4], @rulebook)
    assert(nfa_design.accepts?('bab'))
    assert(nfa_design.accepts?('bbbb'))
    assert(!nfa_design.accepts?('bbabb'))
  end
end

class TestFreeMovesRulebook < Test::Unit::TestCase
  def setup
    @rulebook = NFARulebook.new([FARule.new(1, nil, 2), FARule.new(1, nil, 4),
                                FARule.new(2, 'a', 3), FARule.new(3, 'a', 2),
                                FARule.new(4, 'a', 5), FARule.new(5, 'a', 6),
                                FARule.new(6, 'a', 4)])
  end

  def test_free_moves
    assert_equal(@rulebook.next_states(Set[1], nil), Set[2, 4])
  end

  def test_follow_free_moves
    assert_equal(@rulebook.follow_free_moves(Set[1]), Set[1,2,4])
  end

  def test_nfa_design
    nfa_design = NFADesign.new(1, [2, 4], @rulebook)
    
    assert(nfa_design.accepts?('aa'))
    
    assert(nfa_design.accepts?('aaa'))
   
    assert(!nfa_design.accepts?('aaaaa'))
    
    assert(nfa_design.accepts?('aaaaaa'))
  end
end


