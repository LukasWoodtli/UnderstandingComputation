#!/usr/bin/env ruby

require_relative "app.rb"
require "test/unit" 


class TestReduce < Test::Unit::TestCase
  def test_reducible1
    assert(Add.new(Number.new(1), Number.new(2)).reducible?)
  end

  def test_reducible2
    assert(!Number.new(1).reducible?)
  end

  def test_reduce
    expression = Add.new(
                 Multiply.new(Number.new(1), Number.new(2)),
                 Multiply.new(Number.new(3), Number.new(4))
             )
             
    assert(expression.reducible?)
    expression = expression.reduce
    assert_equal("<<2 + 3 * 4>>", expression.inspect)

    assert(expression.reducible?)
    expression = expression.reduce
    assert_equal("<<2 + 12>>", expression.inspect)


    assert(expression.reducible?)
    expression = expression.reduce
    assert_equal("<<14>>", expression.inspect) 

    assert(!expression.reducible?)

  end
end
