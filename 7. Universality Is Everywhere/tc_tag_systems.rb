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

  def test_even_odd

    rulebook = TagRulebook.new(2, [TagRule.new('a', 'cc'),
                                   TagRule.new('b', 'd'),
                                   TagRule.new('c', 'eo'),
                                   TagRule.new('d', ''),
                                   TagRule.new('e', 'e')])

    # even
    system = TagSystem.new('aabbbbbbbb', rulebook)

    test = system.run
    assert_equal('e', test)

    # odd
    system = TagSystem.new('aabbbbbbbbbb', rulebook)

    test = system.run
    assert_equal('o', test)
  end
end


class TestCyclicTagSystems < Test::Unit::TestCase
  def test_cyclic_tag_system
    rulebook = CyclicTagRulebook.new([CyclicTagRule.new('1'),
                                      CyclicTagRule.new('0010'),
                                      CyclicTagRule.new('10')])

    system = TagSystem.new('11', rulebook)

    16.times do
      system.step
    end

    assert_equal('00101', system.current_string)


    20.times do
      system.step
    end

    assert_equal('101', system.current_string)
  end

  def test_alphabet_and_encoder
    rulebook = TagRulebook.new(2, [TagRule.new('a', 'ccdd'),
                                   TagRule.new('b', 'dd')])

    system = TagSystem.new('aabbbb', rulebook)

    assert_equal(['a', 'b', 'c', 'd'], system.alphabet)

    encoder = system.encoder

    assert_equal("0010", encoder.encode_character('c'))

    assert_equal("001010000100", encoder.encode_string('cab'))

    #rule = system.rulebook.rules.first
  end

  def test_to_cyclic
    rulebook = TagRulebook.new(2, [TagRule.new('a', 'ccdd'),
                                   TagRule.new('b', 'dd')])

    system = TagSystem.new('aabbbb', rulebook)

    cyclic_system = system.to_cyclic

    test = cyclic_system.run

    assert_equal("", test)

  end
end
