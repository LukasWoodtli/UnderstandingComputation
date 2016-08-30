require "test/unit"

require_relative 'ski.rb'

class TestSKI < Test::Unit::TestCase

  def test_symbol_and_call
    x = SKISymbol.new(:x)
    expression = SKICall.new(SKICall.new(S, K), SKICall.new(I, x))

    assert_equal("S[K][I[x]]", expression.to_s)

    y, z = SKISymbol.new(:y), SKISymbol.new(:z)
    assert_equal("x[z][y[z]]", S.call(x, y, z).to_s)
  end
end
