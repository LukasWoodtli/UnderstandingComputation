#!/usr/bin/env ruby

require_relative "app.rb"

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

