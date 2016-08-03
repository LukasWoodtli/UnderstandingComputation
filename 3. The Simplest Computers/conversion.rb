require_relative 'nfa.rb'

class NFASimulation < Struct.new(:nfa_design)
  def next_state(state, character)
    nfa_design.to_nfa(state).tap { |nfa| nfa.read_character(character)}.current_states
  end
  
  def rules_for(state)
    nfa_design.rulebook.alphabet.map { |charcter| FARule.new(state, character, next_state(state, character))}
  end
  
  def discover_states_and_rules(state)
    rules = states.flat_map { |state| rules_for(state) }
    more_states = rules.map(&:follow).to_set
    
    if more_states.subset?(states)
      [states, rules]
    else
      discover_states_and_rules(states + more_states)
    end
  end
end

