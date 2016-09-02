require "test/unit"

require_relative 'tag_systems.rb'



class TestTagSystems < Test::Unit::TestCase
  def test_tag_system
    rulebook = TagRulebook.new(2,
                               [TagRule.new('a', 'aa'),
                               TagRule.new('b', 'bbbb')])

    system = TagSystem.new('aabbbbbb', rulebook)

    4.times do
      system.step
    end

    assert_equal("aabbbbbbbbbbbb", system.current_string)
  end

  def test_run
    rulebook = TagRulebook.new(2, [TagRule.new('a', 'cc'),
                                   TagRule.new('b', 'dddd')])

    system = TagSystem.new('aabbbbbb', rulebook)

    test = system.run
    assert_equal("ccdddddddddddd", test)
  end

  def test_halving
    rulebook = TagRulebook.new(2, [TagRule.new('a', 'cc'),
                                   TagRule.new('b', 'd')])

    system = TagSystem.new('aabbbbbbbbbbbb', rulebook)

    test = system.run

    assert_equal('ccdddddd', test)
  end

  def test_inc
    rulebook = TagRulebook.new(2, [TagRule.new('a', 'ccdd'),
                                   TagRule.new('b', 'dd')])

    system = TagSystem.new('aabbbb', rulebook)

    test = system.run
    assert_equal("ccdddddd", test)
  end

  def test_double_and_inc
    rulebook = TagRulebook.new(2, [TagRule.new('a', 'cc'), 
                                   TagRule.new('b', 'dddd'), # doubling
                                   TagRule.new('c', 'eeff'),
                                   TagRule.new('d', 'ff')])  # increment

    system = TagSystem.new('aabbbb', rulebook)

    test = system.run
    assert_equal('eeffffffffff', test)
  end
end
