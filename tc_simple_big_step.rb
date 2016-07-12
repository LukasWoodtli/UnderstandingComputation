#!/usr/bin/env ruby
# coding: utf-8

require_relative "simple_big_step.rb"
require "test/unit" 
require "stringio"

def expect_std_out(exp_string, expr)
  begin
    old_stdout = $stdout
    $stdout = StringIO.new('','w')

    expr

    assert(exp_string, $stdout.string)
  ensure
    $stdout = old_stdout
  end
end



class TestEvaluate < Test::Unit::TestCase
  def test_eval1
       expect_std_out("<<23>>", Number.new(23).evaluate({}))
  end

  def test_eval2
    expect_std_out("<<23>>", Variable.new(:x).evaluate({x: Number.new(23)}))
  end

  def test_eval3
    expect_std_out("<<true>>", LessThan.new(
                                 Add.new(Variable.new(:x), 
                                         Number.new(2)), Variable.new(:y)
                               ).evaluate({x: Number.new(2), y: Number.new(5) }))
  end
end
