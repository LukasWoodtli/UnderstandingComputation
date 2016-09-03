require 'test/unit'

require_relative 'main.rb'

class TestMain < Test::Unit::TestCase

  def test_euclid
    assert_equal(6, euclid(18, 12))
    assert_equal(1, euclid(867, 5309))
  end

  def test_program
    assert_equal(["01110000", "01110101", "01110100", "01110011",
                  "00100000", "00100111", "01101000", "01100101",
                  "01101100", "01101100", "01101111", "00100000",
                  "01110111", "01101111", "01110010", "01101100",
                  "01100100", "00100111"], $bytes_in_binary)

    assert_equal(9796543849500706521102980495717740021834791,
                 $number)

    assert_equal(["1110000", "01110101", "01110100", "01110011",
                  "00100000", "00100111", "01101000", "01100101",
                  "01101100", "01101100", "01101111", "00100000",
                  "01110111", "01101111", "01110010", "01101100",
                  "01100100", "00100111"], $bytes_in_binary_reverted)

    program = $bytes_in_binary_reverted.map { |string| string.to_i(2).chr }.join
    assert_equal("puts 'hello world'", program)

    eval program
  end

  def test_evaluate
    test = evaluate('print $stdin.read.reverse', 'hello world')
    assert_equal("dlrow olleh", test)
  end

  def test_evaluate_on_itself
    test = evaluate_on_itself('print $stdin.read.reverse')
    assert_equal("esrever.daer.nidts$ tnirp", test)
  end
end
