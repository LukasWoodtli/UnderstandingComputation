#!/usr/bin/env ruby
# coding: utf-8

require_relative "simple_denotational.rb"
require "test/unit" 
require "stringio"


class TestToRuby < Test::Unit::TestCase
  def test_number_to_ruby
    assert_equal("-> e { 5 }", Number.new(5).to_ruby)
  end

  def test_boolean_to_ruby
    assert_equal("-> e { false }", Boolean.new(false).to_ruby)
  end

  def test_eval
    proc = eval(Number.new(5).to_ruby)
    puts proc.call({})
    assert_equal(5, proc.call({}))


    proc = eval(Boolean.new(false).to_ruby)

    assert_equal(false, proc.call({}))
  end

  def test_variable
    expression = Variable.new(:x)
    assert_equal("-> e { e[:x] }", expression.to_ruby)

    proc = eval(expression.to_ruby)
    assert_equal(7, proc.call({ x: 7}))
  end

  def test_add
    assert_equal("-> e { (-> e { e[:x] }).call(e) + (-> e { 1 }).call(e) }", 
                 Add.new(Variable.new(:x), Number.new(1)).to_ruby)
  end

  def test_less_than
    assert_equal("-> e { (-> e { (-> e { e[:x] }).call(e) + (-> e { 1 }).call(e) }).call(e) < (-> e { 3 }).call(e) }",
         LessThan.new(Add.new(Variable.new(:x), Number.new(1)), Number.new(3)).to_ruby)
  end

  def test_complex
    environment = {x: 3 }
    proc = eval(Add.new(Variable.new(:x), Number.new(1)).to_ruby)
    assert_equal(4, proc.call(environment))

    proc = eval(LessThan.new(Add.new(Variable.new(:x), Number.new(1)), Number.new(3)).to_ruby)
    
    assert_equal(false, proc.call(environment))
    
  end

  def test_assign
    statement = Assign.new(:y, Add.new(Variable.new(:x), Number.new(1)))
    assert_equal("-> e { e.merge({ :y => (-> e { (-> e { e[:x] }).call(e) + (-> e { 1 }).call(e) }).call(e) }) }", 
                 statement.to_ruby)
  end
     
  def test_while
    statement = While.new(LessThan.new(Variable.new(:x), Number.new(5)),
                          Assign.new(:x, Multiply.new(Variable.new(:x),
                                                      Number.new(3))))
    assert_equal("-> e { while (-> e { (-> e { e[:x] }).call(e) < (-> e { 5 }).call(e) }).call(e); e = (-> e { e.merge({ :x => (-> e { (-> e { e[:x] }).call(e) * (-> e { 3 }).call(e) }).call(e) }) }).call(e); end; e }",
                statement.to_ruby)

    proc = eval(statement.to_ruby)
    assert_equal({x: 9}, proc.call({x: 1}))
  end
end
