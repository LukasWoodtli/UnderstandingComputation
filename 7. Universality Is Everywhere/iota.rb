# coding: utf-8
require_relative "ski.rb"

IOTA = SKICombinator.new('ɩ')

# reduce ɩ[a] to s[S][K]
def IOTA.call(a)
  SKICall.new(SKICall.new(a, S), K)
end

def IOTA.callable?(*arguments)
  arguments.length == 1
end

class SKISymbol
  def to_iota
    self
  end
end

class SKICall
  def to_iota
    SKICall.new(left.to_iota, right.to_iota)
  end
end


# Replace S with ɩ[ɩ[ɩ[ɩ[ɩ]]]]
def S.to_iota
  SKICall.new(IOTA, SKICall.new(IOTA, SKICall.new(IOTA, SKICall.new(IOTA, IOTA))))
end

# Replace K with ɩ[ɩ[ɩ[ɩ]]]
def K.to_iota
  SKICall.new(IOTA, SKICall.new(IOTA, SKICall.new(IOTA, IOTA)))
end

# Replace I with ɩ[ɩ]
def I.to_iota
  SKICall.new(IOTA, IOTA)
end
