# coding: utf-8
require "test/unit"

require_relative 'iota.rb'

class TestIota < Test::Unit::TestCase
  def test_reduce_s
    expression = S.to_iota
    assert_equal("ɩ[ɩ[ɩ[ɩ[ɩ]]]]", expression.to_s)

    while expression.reducible?
      expression = expression.reduce
    end

    assert_equal("S", expression.to_s)    
  end

  def test_reduce_k
    expression = K.to_iota
    assert_equal("ɩ[ɩ[ɩ[ɩ]]]", expression.to_s)

    while expression.reducible?
      expression = expression.reduce
    end

    assert_equal("K", expression.to_s)    
  end

  def test_reduce_i
    expression = I.to_iota
    assert_equal("ɩ[ɩ]", expression.to_s)

    while expression.reducible?
      expression = expression.reduce
    end

    # equal to I
    assert_equal("S[K][K[K]]", expression.to_s)    
  end

  def test_equal_to_i
    x = SKISymbol.new(:x)

    identity = SKICall.new(SKICall.new(S, K), SKICall.new(K, K))
    expression = SKICall.new(identity, x)

    while expression.reducible?
      expression = expression.reduce
    end

    assert_equal("x", expression.to_s)    
    

  end
end
