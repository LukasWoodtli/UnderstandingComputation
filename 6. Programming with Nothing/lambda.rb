
# church numerals
ZERO = -> p { -> x { x } }
ONE = -> p { -> x { p[x] } }
TWO = -> p { -> x { p[p[x]] } }
THREE = -> p { -> x { p[p[p[x]]] } }

FIVE = -> p { -> x { p[p[p[p[p[x]]]]] } }
FIFTEEN = -> p { -> x { p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[x]]]]]]]]]]]]]]] } }
HUNDRED = -> p { -> x { p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[x]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]] } }

# church booleans
TRUE = -> x { -> y { x }}
FALSE  = -> x { -> y { y }}

# if
IF = -> b { b }

# is zero?
IS_ZERO = -> n { n[-> x {FALSE}][TRUE] }

# pairs
PAIR = -> x { -> y { -> f {f[x][y]}}}
LEFT =  -> p { p[-> x { -> y {x} } ] }
RIGHT = -> p { p[-> x { -> y {y} } ] }

# increment
INCREMENT = -> n { -> p { -> x {p[n[p][x]]}}}

# slide
SLIDE = -> p {PAIR[RIGHT[p]][INCREMENT[RIGHT[p]]]}

# decrement
DECREMENT = -> n { LEFT[n[SLIDE][PAIR[ZERO][ZERO]]] }

def to_integer(proc)
  proc[->n {n + 1}][0]
end

def to_boolean(proc)
  IF[proc][true][false]
end
