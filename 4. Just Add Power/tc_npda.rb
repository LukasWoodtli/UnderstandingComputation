require "test/unit"
require_relative 'npda.rb'

class TestNpda < Test::Unit::TestCase

  def setup
    @rulebook =  NPDARulebook.new([PDARule.new(1, 'a', 1, '$', ['a', '$']),
                                   PDARule.new(1, 'a', 1, 'a', ['a', 'a']),
                                   PDARule.new(1, 'a', 1, 'b', ['a', 'b']),
                                   PDARule.new(1, 'b', 1, '$', ['b', '$']),
                                   PDARule.new(1, 'b', 1, 'a', ['b', 'a']),
                                   PDARule.new(1, 'b', 1, 'b', ['b', 'b']),
                                   PDARule.new(1, nil, 2, '$', ['$', 'a']),
                                   PDARule.new(1, nil, 2, 'a', ['a']),
                                   PDARule.new(1, nil, 2, 'b', ['b']),
                                   PDARule.new(2, 'a', 2, 'a', []),
                                   PDARule.new(2, 'b', 2, 'b', []),
                                   PDARule.new(2, nil, 3, '$', ['$'])])

  end

  def test_configuration
    configuration = PDAConfiguration.new(1, Stack.new(['$']))

    npda = NPDA.new(Set[configuration], [3], @rulebook)

    assert(npda.accepting?)

    npda.read_string('abb')
    assert(!npda.accepting?)

    npda.read_character('a')
    assert(npda.accepting?)

  end

  def test_design
    npda_design = NPDADesign.new(1, '$', [3], @rulebook)

    assert(npda_design.accepts?('abba'))
    assert(npda_design.accepts?('babbaabbab'))
    assert(!npda_design.accepts?('abb'))
    assert(!npda_design.accepts?('baabaa'))
  end

end
