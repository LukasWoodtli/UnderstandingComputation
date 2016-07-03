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
    expression = expression.reduce
    assert_equal("<<2 + 3 * 4>>", expression.inspect)

    assert(expression.reducible?)
    expression = expression.reduce
    assert_equal("<<2 + 12>>", expression.inspect)


    assert(expression.reducible?)
    expression = expression.reduce
    assert_equal("<<14>>", expression.inspect) 

    assert(!expression.reducible?)

  end
end




class TestMachine < Test::Unit::TestCase

  def test_run
    # redirect stdout to string
    begin
      old_stdout = $stdout
      $stdout = StringIO.new('','w')

      Machine.new(
        Add.new(
          Multiply.new(Number.new(1), Number.new(2)),
          Multiply.new(Number.new(3), Number.new(4))
        )
      ).run

      assert_equal("1 * 2 + 3 * 4\n2 + 3 * 4\n2 + 12\n14\n", $stdout.string)
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

      Machine.new(
        LessThan.new(
          Number.new(5),
          Add.new(Number.new(2), Number.new(2))
        )
      ).run

      assert_equal("5 < 2 + 2\n5 < 4\nfalse\n", $stdout.string)
    ensure
      $stdout = old_stdout
    end
  end
end
