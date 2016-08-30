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
  end
end
