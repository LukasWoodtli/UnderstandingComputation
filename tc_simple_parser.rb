#!/usr/bin/env ruby
# coding: utf-8

require "test/unit" 
require 'treetop'
require_relative 'simple_denotational.rb'


class TestParse < Test::Unit::TestCase
  def test_parse

    Treetop.load('simple')
    parse_tree = SimpleParser.new.parse('while (x < 5) { x = x * 3 }')

    expect = "SyntaxNode+While1+While0 offset=0, \"...x < 5) { x = x * 3 }\" (to_ast,condition,body):\n  SyntaxNode offset=0, \"while (\"\n  SyntaxNode+LessThan1+LessThan0 offset=7, \"x < 5\" (to_ast,left,right):\n    SyntaxNode+Variable0 offset=7, \"x\" (to_ast):\n      SyntaxNode offset=7, \"x\"\n    SyntaxNode offset=8, \" < \"\n    SyntaxNode+Number0 offset=11, \"5\" (to_ast):\n      SyntaxNode offset=11, \"5\"\n  SyntaxNode offset=12, \") { \"\n  SyntaxNode+Assign1+Assign0 offset=16, \"x = x * 3\" (to_ast,name,expression):\n    SyntaxNode offset=16, \"x\":\n      SyntaxNode offset=16, \"x\"\n    SyntaxNode offset=17, \" = \"\n    SyntaxNode+Multiply1+Multiply0 offset=20, \"x * 3\" (to_ast,left,right):\n      SyntaxNode+Variable0 offset=20, \"x\" (to_ast):\n        SyntaxNode offset=20, \"x\"\n      SyntaxNode offset=21, \" * \"\n      SyntaxNode+Number0 offset=24, \"3\" (to_ast):\n        SyntaxNode offset=24, \"3\"\n  SyntaxNode offset=25, \" }\""

    assert_equal(expect, parse_tree.inspect)
  end

  def test_ast
    Treetop.load('simple')
    parse_tree = SimpleParser.new.parse('while (x < 5) { x = x * 3 }')
    statement = parse_tree.to_ast
    assert_equal("<<while (x < 5) { x = x * 3 }>>", statement.inspect)
  end

  def test_evaluate
    Treetop.load('simple')
    parse_tree = SimpleParser.new.parse('while (x < 5) { x = x * 3 }')
    statement = parse_tree.to_ast
    statement.evaluate({ x: Number.new(1) })

    assert_equal("-> e { while (-> e { (-> e { e[:x] }).call(e) < (-> e { 5 }).call(e) }).call(e); e = (-> e { e.merge({ :x => (-> e { (-> e { e[:x] }).call(e) * (-> e { 3 }).call(e) }).call(e) }) }).call(e); end; e }", statement.to_ruby)

  end
end
