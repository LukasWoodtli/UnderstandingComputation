require_relative 'nfa.rb'

class NFASimulation < Struct.new(:nfa_design)
  def next_state(state, character)
    nfa_design.to_nfa(state).tap { |nfa| nfa.read_character(character)}.current_states
  end
  
  def rules_for(state)
    nfa_design.rulebook.alphabet.map { |charcter| FARule.new(state, character, next_state(state, character))}
  end
end

