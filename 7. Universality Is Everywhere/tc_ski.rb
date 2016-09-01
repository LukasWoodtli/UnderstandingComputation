require "test/unit"

require_relative 'ski.rb'

class TestSKI < Test::Unit::TestCase

  def test_symbol_and_call
    x = SKISymbol.new(:x)
    expression = SKICall.new(SKICall.new(S, K), SKICall.new(I, x))

    assert_equal("S[K][I[x]]", expression.to_s)

    y, z = SKISymbol.new(:y), SKISymbol.new(:z)
    assert_equal("x[z][y[z]]", S.call(x, y, z).to_s)

    expression = SKICall.new(SKICall.new(SKICall.new(S, x), y),z)
    assert_equal("S[x][y][z]", expression.to_s)

    combinator = expression.left.left.left
    assert_equal("S", combinator.to_s)

    first_argument = expression.left.left.right
    assert_equal("x", first_argument.to_s)

    second_argument = expression.left.right
    assert_equal("y", second_argument.to_s)

    third_argument = expression.right
    assert_equal("z", third_argument.to_s)

    test = combinator.call(first_argument, second_argument, third_argument)
    assert_equal("x[z][y[z]]", test.to_s)

    combinator = expression.combinator
    assert_equal("S", combinator.to_s)

    arguments = expression.arguments
    assert_equal([x, y, z], arguments)

    test = combinator.call(*arguments)
    assert_equal("x[z][y[z]]", test.to_s)


    expression = SKICall.new(SKICall.new(x, y), z)

    combinator = expression.combinator
    assert_equal("x", combinator.to_s)

    arguments = expression.arguments
    assert_equal([y, z], arguments)

    # this is not working (see book)
    # combinator.call(*arguments)

    expression = SKICall.new(SKICall.new(S, x), y)

    combinator = expression.combinator
    assert_equal("S", combinator.to_s)

    arguments = expression.arguments
    assert_equal([x, y], arguments)

    # this is not working (see book)
    # combinator.call(*arguments)

    expression = SKICall.new(SKICall.new(x, y), z)
    assert(!expression.combinator.callable?(*expression.arguments))

    expression = SKICall.new(SKICall.new(S, x), y)
    assert(!expression.combinator.callable?(*expression.arguments))

    expression = SKICall.new(SKICall.new(SKICall.new(S, x), y), z)
    assert(expression.combinator.callable?(*expression.arguments))
  end

  def test_reduce
    x = SKISymbol.new(:x)
    y = SKISymbol.new(:y)

    swap = SKICall.new(SKICall.new(S, SKICall.new(K, SKICall.new(S, I))), K)
    assert_equal("S[K[S[I]]][K]", swap.to_s)

    expression = SKICall.new(SKICall.new(swap, x), y)
    while expression.reducible?
      expression = expression.reduce
    end

    assert_equal("y[x]", expression.to_s)
  end

  def test_as_a_function_of
    x = SKISymbol.new(:x)
    y = SKISymbol.new(:y)
  
    original = SKICall.new(SKICall.new(S,K), I)
    function = original.as_a_function_of(:x)
    assert_equal("S[S[K[S]][K[K]]][K[I]]", function.to_s)

    assert(!function.reducible?)

    expression = SKICall.new(function, y)

    while expression.reducible?
      expression = expression.reduce
    end

    assert_equal("S[K][I]", expression.to_s)
    assert(expression == original)
  end
end
