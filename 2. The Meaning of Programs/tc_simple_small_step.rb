#!/usr/bin/env ruby
# coding: utf-8

require_relative "simple_small_step.rb"
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
  def test_if_else
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

  def test_if
    begin
        old_stdout = $stdout
        $stdout = StringIO.new('','w')

        Machine.new(
          If.new(
          Variable.new(:x),
          Assign.new(:y, Number.new(1)),
          DoNothing.new
        ),
          { x: Boolean.new(false) }
        ).run

       
        assert_equal("if (x) { y = 1 } else { do_nothing }, {:x=><<false>>}\nif (false) { y = 1 } else { do_nothing }, {:x=><<false>>}\ndo_nothing, {:x=><<false>>}\n", $stdout.string)
      ensure
        $stdout = old_stdout
      end
  end
end



class TestSequenceInMachine < Test::Unit::TestCase
  def test_sequence
      # redirect stdout to string
      begin
        old_stdout = $stdout
        $stdout = StringIO.new('','w')

        Machine.new(
          Sequence.new(
            Assign.new(:x, Add.new(Number.new(1), Number.new(1))),
            Assign.new(:y, Add.new(Variable.new(:x), Number.new(3)))
          ), {}
        ).run

        assert_equal("x = 1 + 1; y = x + 3, {}\nx = 2; y = x + 3, {}\ndo_nothing; y = x + 3, {:x=><<2>>}\ny = x + 3, {:x=><<2>>}\ny = 2 + 3, {:x=><<2>>}\ny = 5, {:x=><<2>>}\ndo_nothing, {:x=><<2>>, :y=><<5>>}\n", $stdout.string)
      ensure
        $stdout = old_stdout
      end
  end
end


class TestWhileInMachine < Test::Unit::TestCase
  def test_while
      # redirect stdout to string
      begin
        old_stdout = $stdout
        $stdout = StringIO.new('','w')

        Machine.new(
          While.new(
            LessThan.new(Variable.new(:x), Number.new(5)),
            Assign.new(:x, Multiply.new(Variable.new(:x), Number.new(3)))
          ), { x: Number.new(1) }
        ).run

        assert_equal("while (x < 5) { x = x * 3 }, {:x=><<1>>}\nif (x < 5) { x = x * 3; while (x < 5) { x = x * 3 } } else { do_nothing }, {:x=><<1>>}\nif (1 < 5) { x = x * 3; while (x < 5) { x = x * 3 } } else { do_nothing }, {:x=><<1>>}\nif (true) { x = x * 3; while (x < 5) { x = x * 3 } } else { do_nothing }, {:x=><<1>>}\nx = x * 3; while (x < 5) { x = x * 3 }, {:x=><<1>>}\nx = 1 * 3; while (x < 5) { x = x * 3 }, {:x=><<1>>}\nx = 3; while (x < 5) { x = x * 3 }, {:x=><<1>>}\ndo_nothing; while (x < 5) { x = x * 3 }, {:x=><<3>>}\nwhile (x < 5) { x = x * 3 }, {:x=><<3>>}\nif (x < 5) { x = x * 3; while (x < 5) { x = x * 3 } } else { do_nothing }, {:x=><<3>>}\nif (3 < 5) { x = x * 3; while (x < 5) { x = x * 3 } } else { do_nothing }, {:x=><<3>>}\nif (true) { x = x * 3; while (x < 5) { x = x * 3 } } else { do_nothing }, {:x=><<3>>}\nx = x * 3; while (x < 5) { x = x * 3 }, {:x=><<3>>}\nx = 3 * 3; while (x < 5) { x = x * 3 }, {:x=><<3>>}\nx = 9; while (x < 5) { x = x * 3 }, {:x=><<3>>}\ndo_nothing; while (x < 5) { x = x * 3 }, {:x=><<9>>}\nwhile (x < 5) { x = x * 3 }, {:x=><<9>>}\nif (x < 5) { x = x * 3; while (x < 5) { x = x * 3 } } else { do_nothing }, {:x=><<9>>}\nif (9 < 5) { x = x * 3; while (x < 5) { x = x * 3 } } else { do_nothing }, {:x=><<9>>}\nif (false) { x = x * 3; while (x < 5) { x = x * 3 } } else { do_nothing }, {:x=><<9>>}\ndo_nothing, {:x=><<9>>}\n", $stdout.string)
      ensure
        $stdout = old_stdout
      end
  end
end
