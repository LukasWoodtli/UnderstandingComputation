#!/usr/bin/env ruby

require_relative "app.rb"
require "test/unit" 
require "stringio"


class TestReduce < Test::Unit::TestCase
  def test_reducible1
    assert(Add.new(Number.new(1), Number.new(2)).reducible?)
  end

  def test_reducible2
    assert(!Number.new(1).reducible?)
  end

  def test_reduce
    expression = Add.new(
                 Multiply.new(Number.new(1), Number.new(2)),
                 Multiply.new(Number.new(3), Number.new(4))
             )
             
    assert(expression.reducible?)
    expression = expression.reduce({})
    assert_equal("<<2 + 3 * 4>>", expression.inspect)

    assert(expression.reducible?)
    expression = expression.reduce({})
    assert_equal("<<2 + 12>>", expression.inspect)


    assert(expression.reducible?)
    expression = expression.reduce({})
    assert_equal("<<14>>", expression.inspect) 

    assert(!expression.reducible?)

  end
end




class TestMachineOldOld < Test::Unit::TestCase

  def test_run
    # redirect stdout to string
    begin
      old_stdout = $stdout
      $stdout = StringIO.new('','w')

      MachineOld.new(
        Add.new(
          Multiply.new(Number.new(1), Number.new(2)),
          Multiply.new(Number.new(3), Number.new(4))
        ),
        {}
      ).run

      assert_equal("1 * 2 + 3 * 4\n2 + 3 * 4\n2 + 12\n14\n", $stdout.string)
    ensure
      $stdout = old_stdout
    end
  end

end


class TestMachineOld < Test::Unit::TestCase

  def test_run
    # redirect stdout to string
    begin
      old_stdout = $stdout
      $stdout = StringIO.new('','w')

      MachineOld.new(
        Add.new(Number.new(2), Number.new(2)),
        {}
      ).run

      assert_equal("2 + 2\n4\n", $stdout.string)
    ensure
      $stdout = old_stdout
    end
  end

end


class TestReduceLessThan < Test::Unit::TestCase
  def test_run
    # redirect stdout to string
    begin
      old_stdout = $stdout
      $stdout = StringIO.new('','w')

      MachineOld.new(
        LessThan.new(
          Number.new(5),
          Add.new(Number.new(2), Number.new(2))
        ),
        {}
      ).run

      assert_equal("5 < 2 + 2\n5 < 4\nfalse\n", $stdout.string)
    ensure
      $stdout = old_stdout
    end
  end
end

class TestEnvironment < Test::Unit::TestCase
  def test_run
    # redirect stdout to string
    begin
      old_stdout = $stdout
      $stdout = StringIO.new('','w')

      MachineOld.new(
          Add.new(Variable.new(:x), Variable.new(:y)),
          {x: Number.new(3), y: Number.new(4)}
      ).run

      assert_equal("x + y\n3 + y\n3 + 4\n7\n", $stdout.string)
    ensure
      $stdout = old_stdout
    end
  end
end

class TestAssignment < Test::Unit::TestCase
  def test_assign
    statement = Assign.new(:x, Add.new(Variable.new(:x), Number.new(1)))
    environment = {x: Number.new(2)}

    assert(statement.reducible?)

    statement, environment = statement.reduce(environment)
    assert_equal("<<x = 2 + 1>>", statement.inspect)
    assert_equal("{:x=><<2>>}", environment.inspect)

    statement, environment = statement.reduce(environment)
    assert_equal("<<x = 3>>", statement.inspect)
    assert_equal("{:x=><<2>>}", environment.inspect)

    statement, environment = statement.reduce(environment)
    assert_equal("<<do_nothing>>", statement.inspect)
    assert_equal("{:x=><<3>>}", environment.inspect)

    assert(!statement.reducible?)


  end

end


class TestAssignInMachine < Test::Unit::TestCase
  def test_assign
      # redirect stdout to string
      begin
        old_stdout = $stdout
        $stdout = StringIO.new('','w')

        Machine.new(Assign.new(:x, Add.new(Variable.new(:x), Number.new(1))),
                    {x: Number.new(2)}
        ).run

        assert_equal("x = x + 1, {:x=><<2>>}\nx = 2 + 1, {:x=><<2>>}\nx = 3, {:x=><<2>>}\ndo_nothing, {:x=><<3>>}\n", $stdout.string)
      ensure
        $stdout = old_stdout
      end
  end
end

class TestIfInMachine < Test::Unit::TestCase
  def test_if
    begin
        old_stdout = $stdout
        $stdout = StringIO.new('','w')

        Machine.new(
          If.new(
          Variable.new(:x),
          Assign.new(:y, Number.new(1)),
          Assign.new(:y, Number.new(2))
        ),
          { x: Boolean.new(true) }
        ).run

       
        assert_equal("if (x) { y = 1 } else { y = 2 }, {:x=><<true>>}\nif (true) { y = 1 } else { y = 2 }, {:x=><<true>>}\ny = 1, {:x=><<true>>}\ndo_nothing, {:x=><<true>>, :y=><<1>>}\n", $stdout.string)
      ensure
        $stdout = old_stdout
      end
  end
end
