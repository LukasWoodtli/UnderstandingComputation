require "test/unit"
require_relative 'regexp.rb'

class TestRegexp < Test::Unit::TestCase

  def test_string
    pattern = Repeat.new(
                Choose.new(
                  Concatenate.new(Literal.new('a'),
                                  Literal.new('b')),
                  Literal.new('a')
                )
              )
    assert_equal('(ab|a)*', pattern.to_s)
  end

  def test_empty
    nfa_design = Empty.new.to_nfa_design

    assert(nfa_design.accepts?(''))

    assert(!nfa_design.accepts?('a'))
  end

  def test_literal
    nfa_design = Literal.new('a').to_nfa_design

    assert(!nfa_design.accepts?(''))

    assert(nfa_design.accepts?('a'))

    assert(!nfa_design.accepts?('b'))
  end

  def test_matches
    assert(!Empty.new.matches?('a'))

    assert(Literal.new('a').matches?('a'))
  end

end