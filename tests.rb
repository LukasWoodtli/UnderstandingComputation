#!/usr/bin/env ruby

require_relative "app.rb"
require "test/unit" 


def expect value
  ret = yield
  raise StandardError, "Expected #{value}, obtained #{ret}!" unless ret == value
end

add = Add.new(
  Multiply.new(Number.new(1), Number.new(2)),
  Multiply.new(Number.new(3), Number.new(4))
)

print add

#########################################
expect false do
  Number.new(1).reducible?
end

expect true do
  Add.new(Number.new(1), Number.new(2)).reducible?
end


###############################################

expression = Add.new(
                 Muliply.new(Number.new(1), Number.new(2)),
                 Muliply.new(Number.new(3), Number.new(4))
             )

expect true do
  expression.reducible?
end




class TestReduce < Test::Unit::TestCase
  def test_reduce1
    assert_equal("<<2 + 3 * 4>>", expression.reduce) 
  end
end