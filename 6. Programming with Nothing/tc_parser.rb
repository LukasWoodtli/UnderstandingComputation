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

  def test_replace_expressions
    expression = LCVariable.new(:x)

    test = expression.replace(:x, LCFunction.new(:y, LCVariable.new(:y)))
    assert_equal("-> y { y }", test.to_s)

    test = expression.replace(:z, LCFunction.new(:y, LCVariable.new(:y)))
    assert_equal("x", test.to_s)

    expression = LCCall.new(LCCall.new(LCCall.new(
                                        LCVariable.new(:a),
                                        LCVariable.new(:b)),
                                       LCVariable.new(:c)),
                            LCVariable.new(:b))

    test = expression.replace(:a, LCVariable.new(:x))
    assert_equal("x[b][c][b]", test.to_s)

    test = expression.replace(:b, LCFunction.new(:x, LCVariable.new(:x)))
    assert_equal("a[-> x { x }][c][-> x { x }]", test.to_s)
  end

  def test_replace_functions
    expression = LCFunction.new(:y, LCCall.new(LCVariable.new(:x),
                                               LCVariable.new(:y)))

    test = expression.replace(:x, LCVariable.new(:z))
    assert_equal("-> y { z[y] }", test.to_s)

    test = expression.replace(:y, LCVariable.new(:z))
    assert_equal("-> y { x[y] }", test.to_s)

  end

  def test_replace_functions_with_scope
    expression = LCCall.new(LCCall.new(LCVariable.new(:x),
                                       LCVariable.new(:y)),
                            LCFunction.new(:y, LCCall.new(LCVariable.new(:y),
                                                          LCVariable.new(:x))))
    assert_equal("x[y][-> y { y[x] }]", expression.to_s)
    test = expression.replace(:x, LCVariable.new(:z))
    assert_equal("z[y][-> y { y[z] }]", test.to_s)

    test = expression.replace(:y, LCVariable.new(:z))
    assert_equal("x[z][-> y { y[x] }]", test.to_s)
  end

  def test_replace_not_working
    expression = LCFunction.new(:x,
                               LCCall.new(LCVariable.new(:x),
                                          LCVariable.new(:y)))

    assert_equal("-> x { x[y] }", expression.to_s)

    replacement = LCCall.new(LCVariable.new(:z),
                             LCVariable.new(:x))

    assert_equal("z[x]", replacement.to_s)
    
    test = expression.replace(:y, replacement)
    
    # this replacement is wrong: we plug in a z[x] but x is a captured
    # variable in the expression but in z[x] x is a free variable
    # and should remain free after the replacement
    # see book p. 224f
    # assert_equal("-> x { x[z[x]] }", test.to_s)
  end

  def test_function_call
    function = LCFunction.new(:x,  LCFunction.new(:y,
                                        LCCall.new(LCVariable.new(:x),
                                                   LCVariable.new(:y))))
    assert_equal("-> x { -> y { x[y] } }", function.to_s)

    argument = LCFunction.new(:z, LCVariable.new(:z))
    assert_equal("-> z { z }", argument.to_s)

    test = function.call(argument)
    assert_equal("-> y { -> z { z }[y] }", test.to_s)
  end

end
