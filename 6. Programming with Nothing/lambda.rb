
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

# addition, subtraction, multiplication, power
ADD = -> m { -> n { n[INCREMENT][m] }}
SUBTRACT = -> m { -> n { n[DECREMENT][m] }}

MULTIPLY = -> m { -> n { n[ADD[m]][ZERO]}}

POWER = -> m { -> n { n[MULTIPLY[m]][ONE]}}

# less or equal
IS_LESS_OR_EQUAL = -> m { -> n { IS_ZERO[SUBTRACT[m][n]] }}

# Y- and Z-combinator
Y = -> f { -> x { f[x[x]] } [ -> x { f[x[x]] } ] } # loops forever in ruby: eager evaluation
Z = -> f { -> x { f[-> y {x[x][y]}] } [ -> x { f[ -> y {x[x][y]}] } ] }

# modulo
MOD = Z[ -> f { -> m { -> n { IF[IS_LESS_OR_EQUAL[n][m]][-> x {f[SUBTRACT[m][n]][n][x]}][m] }}}]

# lists
EMPTY = PAIR[TRUE][TRUE]
UNSHIFT = -> l { -> x { PAIR[FALSE][PAIR[x][l]]}}
IS_EMPTY = LEFT
FIRST = -> l {LEFT[RIGHT[l]]}
REST = -> l {RIGHT[RIGHT[l]]}

# range
RANGE = Z[-> f { -> m { -> n { IF[IS_LESS_OR_EQUAL[m][n]][ -> x { UNSHIFT[f[INCREMENT[m]][n]][m][x]}][EMPTY]}}}]

# fold, map
FOLD = Z[-> f { -> l { -> x { -> g {IF[IS_EMPTY[l]][x][-> y { g[f[REST[l]][x][g]][FIRST[l]][y]} ]}}}}]
MAP = -> k { -> f { FOLD[k][EMPTY][ -> l { -> x {UNSHIFT[l][f[x]]}}]}}

# push to list
PUSH = -> l { -> x { FOLD[l][UNSHIFT[EMPTY][x]][UNSHIFT] }}

# division
DIV = Z[-> f { -> m { -> n { IF[IS_LESS_OR_EQUAL[n][m]][ -> x { INCREMENT[f[SUBTRACT[m][n]][n]][x]}][ZERO] }}}]

# more numbers and chars
TEN = MULTIPLY[TWO][FIVE]
B = TEN
F = INCREMENT[B]
I = INCREMENT[F]
U = INCREMENT[I]
ZED = INCREMENT[U]

# integer to list of digits
TO_DIGITS = Z[ -> f { -> n { PUSH[IF[IS_LESS_OR_EQUAL[n][DECREMENT[TEN]]][EMPTY][ -> x {f[DIV[n][TEN]][x]} ]][MOD[n][TEN]]}}]

FIZZ = UNSHIFT[UNSHIFT[UNSHIFT[UNSHIFT[EMPTY][ZED]][ZED]][I]][F]
BUZZ = UNSHIFT[UNSHIFT[UNSHIFT[UNSHIFT[EMPTY][ZED]][ZED]][U]][B]
FIZZBUZZ = UNSHIFT[UNSHIFT[UNSHIFT[UNSHIFT[BUZZ][ZED]][ZED]][I]][F]

### Advanced programming rechniques

# infinite streams
ZEROS = Z[ -> f {UNSHIFT[f][ZERO]} ]
UPWARDS_OF = Z[ -> f { -> n { UNSHIFT[ -> x {f[INCREMENT[n]][x]}][n]}}  ]
MULTIPLES_OF = -> m { Z[ -> f { -> n { UNSHIFT[ -> x { f[ADD[m][n]][x]}][n]} }][m]}
MULTIPLY_STREAMS = Z[ -> f { -> k { -> l { UNSHIFT[ -> x { f[REST[k]][REST[l]][x]}][MULTIPLY[FIRST[k]][FIRST[l]]] }}} ]

# mod without recursion
MOD_ALT = -> m { -> n { m[ -> x {IF[IS_LESS_OR_EQUAL[n][x]][SUBTRACT[x][n]][x] }][m]}} 
COUNTDOWN =  -> p { PAIR[UNSHIFT[LEFT[p]][RIGHT[p]]][DECREMENT[RIGHT[p]]]}
RANGE_ALT = -> m { -> n { LEFT[INCREMENT[SUBTRACT[n][m]][COUNTDOWN][PAIR[EMPTY][n]]] }}

def to_integer(proc)
  proc[->n {n + 1}][0]
end

def to_boolean(proc)
  IF[proc][true][false]
end

def to_array(proc, count = nil)
  array = []

  until to_boolean(IS_EMPTY[proc]) || count == 0
    array.push(FIRST[proc])
    proc = REST[proc]
    count = count - 1 unless count.nil?
  end

  array
end

def to_char(c)
  '0123456789BFiuz'.slice(to_integer(c))
end

def to_string(s)
  to_array(s).map { |c| to_char(c) }.join
end


