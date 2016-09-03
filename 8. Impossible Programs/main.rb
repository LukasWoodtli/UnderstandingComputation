require 'stringio'

def euclid(x, y)
  until x == y
    if x > y
      x = x - y
    else
      y = y -x
    end
  end

  x
end



program = "puts 'hello world'"

$bytes_in_binary = program.bytes.map { |byte| byte.to_s(2).rjust(8, '0') }
$number = $bytes_in_binary.join.to_i(2)

$bytes_in_binary_reverted = $number.to_s(2).scan(/.+?(?=.{8}*\z)/)


def evaluate(program, input)
  old_stdin, old_stdout = $stdin, $stdout
  $stdin, $stdout = StringIO.new(input), (output = StringIO.new)

  begin
    eval program
  rescue Exception => e
    output.puts(e)
  ensure
    $stdin, $stdout = old_stdin, old_stdout
  end

  output.string
end


def evaluate_on_itself(program)
  evaluate(program, program)
end
