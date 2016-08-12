require "test/unit"
require_relative 'parser.rb'

class TestParser < Test::Unit::TestCase

  def test_lexical_analyzer
    assert_equal(LexicalAnalyzer.new('y = x * 7').analyze, 
                 ["v", "=", "v", "*", "n"])

    assert_equal(LexicalAnalyzer.new('while (x < 5) { x = x * 3 }').analyze, 
                 ["w", "(", "v", "<", "n", ")", "{", "v", "=", "v", "*", "n", "}"])

    assert_equal(
      LexicalAnalyzer.new(
        'if (x < 10) { y = true; x = 0 } else { do-nothing}').analyze, 
      ["i", "(", "v", "<", "n", ")", "{", "v", "=", "b", ";", "v", "=", "n", "}", "e", "{", "d", "}"])
  end

end

