require "test/unit"
require_relative 'regexp.rb'
require 'treetop'

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

  def test_concatenate_ab
    pattern = Concatenate.new(Literal.new('a'), Literal.new('b'))

    assert(!pattern.matches?('a'))
    assert(pattern.matches?('ab'))
    assert(!pattern.matches?('abc'))
  end

  def test_concatenate_abc
    pattern = Concatenate.new(Literal.new('a'),
                              Concatenate.new(Literal.new('b'),
                                              Literal.new('c')))

    assert(!pattern.matches?('a'))
    assert(!pattern.matches?('ab'))
    assert(pattern.matches?('abc'))
  end

  def test_choose
    pattern = Choose.new(Literal.new('a'), Literal.new('b'))

    assert(pattern.matches?('a'))
    assert(pattern.matches?('b'))
    assert(!pattern.matches?('c'))
  end

  def test_repeat
    pattern = Repeat.new(Literal.new('a'))

    assert(pattern.matches?(''))
    assert(pattern.matches?('a'))
    assert(pattern.matches?('aaaa'))
    assert(!pattern.matches?('b'))
  end

  def test_match
    pattern = Repeat.new(
                  Concatenate.new(
                    Literal.new('a'),
                    Choose.new(Empty.new , Literal.new('b'))))

    assert(pattern.matches?(''))
    assert(pattern.matches?('a'))
    assert(pattern.matches?('ab'))
    assert(pattern.matches?('aba'))
    assert(pattern.matches?('abab'))
    assert(pattern.matches?('abaab'))
    assert(!pattern.matches?('abba'))
  end


  def test_parser
    this_dir = File.expand_path(File.dirname(__FILE__))

    Treetop.load(File.join(this_dir, 'regexp'))

    parse_tree = PatternParser.new.parse('(a(|b))*')
    pattern = parse_tree.to_ast

    assert_equal("/(a(|b))*/", pattern.inspect)

    assert(pattern.matches?('abaab'))
    assert(!pattern.matches?('abba'))
  end
end

