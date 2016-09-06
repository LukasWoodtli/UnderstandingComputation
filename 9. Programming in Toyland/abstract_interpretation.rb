class Sign < Struct.new(:name)
  NEGATIVE, ZERO, POSITIVE = [:negative, :zero, :positive].map { |name| new(name) }

  def inspect
    "#<Sign #{name}>"
  end

  def *(other_sign)
    if [self, other_sign].include?(ZERO)
      ZERO
    elsif self == other_sign
      POSITIVE
    else
      NEGATIVE
    end
  end
end


class Numeric
  def sign
    if self < 0
      Sign::NEGATIVE
    elsif zero?
      Sign::ZERO
    else
      Sign::POSITIVE
    end
  end
end

