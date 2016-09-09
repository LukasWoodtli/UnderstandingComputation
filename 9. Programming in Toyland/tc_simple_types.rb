require 'test/unit'

require_relative 'simple_types.rb'

class TestTypes < Test::Unit::TestCase
  def test_expressions
    assert_equal(Type::NUMBER, Add.new(Number.new(1), Number.new(2)).type({}))
    assert_equal(nil, Add.new(Number.new(1), Boolean.new(true)).type({}))
    assert_equal(Type::BOOLEAN, LessThan.new(Number.new(1), Number.new(2)).type({}))
    assert_equal(nil, LessThan.new(Number.new(1), Boolean.new(true)).type({}))

    expression = Add.new(Variable.new(:x), Variable.new(:y))
    assert_equal("x + y", expression.to_s)
    assert_equal(nil, expression.type({}))
    assert_equal(Type::NUMBER, expression.type({ x: Type::NUMBER, y: Type::NUMBER }))
    assert_equal(nil, expression.type({ x: Type::NUMBER, y: Type::BOOLEAN }))
  end

  def test_statements
    assert_equal(Type::VOID, If.new(
                               LessThan.new(Number.new(1), Number.new(2)),
                               DoNothing.new, DoNothing.new).type({}))

    assert_equal(nil, If.new(
                               Add.new(Number.new(1), Number.new(2)),
                               DoNothing.new, DoNothing.new).type({}))

    assert_equal(Type::VOID, While.new(
                               Variable.new(:x), DoNothing.new).type({ x: Type::BOOLEAN}))

    assert_equal(nil, While.new(
                               Variable.new(:x), DoNothing.new).type({ x: Type::NUMBER}))

  end

  def test_while
    statement = While.new(LessThan.new(Variable.new(:x),
                                       Number.new(5)),
                          Assign.new(:x, Add.new(Variable.new(:x),
                                                 Number.new(3))))

    assert_equal(nil, statement.type({}))
    assert_equal(Type::VOID, statement.type({ x: Type::NUMBER }))
    assert_equal(nil, statement.type({ x: Type::BOOLEAN }))

  end

  def test_endless_loop
    statement = Sequence.new(Assign.new(:x, Number.new(0)),
                             While.new(Boolean.new(true),
                                       Assign.new(:x,
                                                  Add.new(Variable.new(:x),
                                                              Number.new(1)))))
    assert_equal("x = 0; while (true) { x = x + 1 }", statement.to_s)
    assert_equal(Type::VOID, statement.type({ x: Type::NUMBER }))

    # This would loop forever
    # statement.evaluate({})

    statement = Sequence.new(statement,
                             Assign.new(:x, Boolean.new(true)))

    assert_equal(nil, statement.type({ x: Type::NUMBER }))
  end

  def test_restrictive
    statement = Sequence.new(
      If.new(Variable.new(:b),
             Assign.new(:x, Number.new(6)),
             Assign.new(:x, Boolean.new(true))
             ),
      Sequence.new(If.new(Variable.new(:b),
                          Assign.new(:y, Variable.new(:x)),
                          Assign.new(:y, Number.new(1))
                          ),
                   Assign.new(:z, Add.new(Variable.new(:y), Number.new(1)))))

    assert_equal(
      "if (b) { x = 6 } else { x = true }; if (b) { y = x } else { y = 1 }; z = y + 1", 
      statement.to_s)
  
    assert_equal(
      { b: Boolean.new(true), x: Number.new(6), y: Number.new(6), z: Number.new(7)},
      statement.evaluate({ b: Boolean.new(true) }))

    assert_equal(
      { b: Boolean.new(false), x: Boolean.new(true), y: Number.new(1), z: Number.new(2)},
      statement.evaluate({ b: Boolean.new(false) }))


    assert_equal(nil, statement.type({}))

    context = { b: Type::BOOLEAN, y: Type::NUMBER, z: Type::NUMBER }
    assert_equal(nil, statement.type(context))
    assert_equal(nil, statement.type(context.merge({ x: Type::NUMBER })))
    assert_equal(nil, statement.type(context.merge({ x: Type::BOOLEAN })))

  end

  def test_unasign
    statement = Assign.new(:x, Add.new(Variable.new(:x),
                                       Number.new(1)))

    assert_equal(Type::VOID, statement.type({ x: Type::NUMBER }))

    # this fails even if typing check succeded
    # statement.evaluate({})
  end
end
