require_relative "../2. The Meaning of Programs/simple_denotational.rb"

class Type < Struct.new(:name)
  NUMBER, BOOLEAN = [:number, :boolean].map { |name| new(name) }
  VOID = new(:void)

  def inspect
    "#<Type #{name}>"
  end
end

class Number
  def type(context)
    Type::NUMBER
  end
end

class Boolean
  def type(context)
    Type::Boolean
  end
end

class Add
  def type(context)
    if left.type(context) == Type::NUMBER && right.type(context) == Type::NUMBER
      Type::NUMBER
    end
  end
end

class LessThan
  def type(context)
    if left.type(context) == Type::NUMBER && right.type(context) == Type::NUMBER
      Type::BOOLEAN
    end
  end
end

class Variable
  def type(context)
    context[name]
  end
end

class DoNothing
  def type(context)
    Type::VOID
  end
end

class Sequence
  def type(context)
    if first.type(context) == Type::VOID && second.type(context) == Type::VOID
      Type::VOID
    end
  end
end

class If
  def type(context)
    if condition.type(context) == Type::BOOLEAN &&
       consequence.type(context) == Type::VOID &&
       alternative.type(context) == Type::VOID

      Type::VOID
    end
  end
end

class While
  def type(context)
    if condition.type(context) == Type::BOOLEAN &&
       body.type(context) == Type::VOID

      Type::VOID
    end
  end
end
