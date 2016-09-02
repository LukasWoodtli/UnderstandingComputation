# coding: utf-8
require "test/unit"

require_relative 'iota.rb'

require 'treetop'

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

  def test_lambda_to_iota
    this_dir = File.expand_path(File.dirname(__FILE__))
    Treetop.load(File.join(this_dir, '../6. Programming with Nothing/lambda_calculus'))

    two = LambdaCalculusParser.new.parse("-> p { -> x { p[p[x]] } }").to_ast
  
    assert_equal("S[S[K[S]][S[K[K]][I]]][S[S[K[S]][S[K[K]][I]]][K[I]]]",
                 two.to_ski.to_s)

    assert_equal("ɩ[ɩ[ɩ[ɩ[ɩ]]]][ɩ[ɩ[ɩ[ɩ[ɩ]]]][ɩ[ɩ[ɩ[ɩ]]][ɩ[ɩ[ɩ[ɩ[ɩ]]]]]][ɩ[ɩ[ɩ[ɩ[ɩ]]]][ɩ[ɩ[ɩ[ɩ]]][ɩ[ɩ[ɩ[ɩ]]]]][ɩ[ɩ]]]][ɩ[ɩ[ɩ[ɩ[ɩ]]]][ɩ[ɩ[ɩ[ɩ[ɩ]]]][ɩ[ɩ[ɩ[ɩ]]][ɩ[ɩ[ɩ[ɩ[ɩ]]]]]][ɩ[ɩ[ɩ[ɩ[ɩ]]]][ɩ[ɩ[ɩ[ɩ]]][ɩ[ɩ[ɩ[ɩ]]]]][ɩ[ɩ]]]][ɩ[ɩ[ɩ[ɩ]]][ɩ[ɩ]]]]", two.to_ski.to_iota.to_s)


    inc = SKISymbol.new(:inc)
    zero = SKISymbol.new(:zero)

    expression = SKICall.new(SKICall.new(two.to_ski.to_iota, inc), zero)

    expression = expression.reduce while expression.reducible?

    assert_equal("inc[inc[zero]]", expression.to_s)

  end
end
