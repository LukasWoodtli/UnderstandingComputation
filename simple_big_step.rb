require_relative "simple_small_step.rb"

class Number
  def evaluate(environment)
    self
  end
end


class Boolean
  def evaluate(environment)
    self
  end
end


class Variable
  def evaluate(environment)
    environment[name]
  end
end


class Add
  def evaluate(environment)
    Number.new(left.evaluate(environment).value + right.evaluate(environment).value)
  end
end

class Multiply
  def evaluate(environment)
    Number.new(left.evaluate(environment).value * right.evaluate(environment).value)
  end
end

class LessThan
  def evaluate(environment)
    Boolean.new(left.evaluate(environment).value < right.evaluate(environment).value)
  end
end

