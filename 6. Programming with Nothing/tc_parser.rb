require "test/unit"
require_relative 'parser.rb'

class TestParser < Test::Unit::TestCase
  def setup
    @one = LCFunction.new(:p, LCFunction.new(:x,
                                   LCCall.new(LCVariable.new(:p),
                                              LCVariable.new(:x))))

    @increment = LCFunction.new(:n, LCFunction.new(:p, LCFunction.new(:x,
                                        LCCall.new(LCVariable.new(:p),
                                            LCCall.new(
                                                LCCall.new(LCVariable.new(:n),
                                                           LCVariable.new(:p)),
                                                LCVariable.new(:x))))))

    @add = LCFunction.new(:m,
                LCFunction.new(:n,
                       LCCall.new(LCCall.new(LCVariable.new(:n), @increment),
                                 LCVariable.new(:m))))
  end

  def test_expressions
    assert_equal("-> p { -> x { p[x] } }", @one.to_s)

    assert_equal("-> n { -> p { -> x { p[n[p][x]] } } }", @increment.to_s)

    assert_equal("-> m { -> n { n[-> n { -> p { -> x { p[n[p][x]] } } }][m] } }",
                 @add.to_s)
  end

  def test_replace
    expression = LCVariable.new(:x)

    test = expression.replace(:x, LCFunction.new(:y, LCVariable.new(:y)))
    assert_equal("-> y { y }", test.to_s)

    test = expression.replace(:z, LCFunction.new(:y, LCVariable.new(:y)))
    assert_equal("x", test.to_s)
  end
end
