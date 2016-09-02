
class TagRule < Struct.new(:first_character,
                           :append_characters)
  def applies_to?(string)
    string.chars.first == first_character
  end

  def follow(string)
    string + append_characters
  end
end

class TagRulebook < Struct.new(:deletion_number, :rules)
  def next_string(string)
    rule_for(string).follow(string).slice(deletion_number..-1)
  end

  def rule_for(string)
    rules.detect { |r| r.applies_to?(string) }
  end

  def applies_to?(string)
    !rule_for(string).nil? && string.length >= deletion_number
  end
end

class TagSystem < Struct.new(:current_string, :rulebook)
  def step
    self.current_string = rulebook.next_string(current_string)
  end

  def run
    while rulebook.applies_to?(current_string)
      # puts current_string
      step
    end

    # puts current_string
    current_string
  end
end


### Cyclic Tag Systems ###

class CyclicTagRule < TagRule
  FIRST_CHARACTER = '1'

  def initialize(append_characters)
    super(FIRST_CHARACTER, append_characters)
  end

  def inspect
    '#<CyclicTagRule #{append_characters.inspect}>'
  end
end

class CyclicTagRulebook < Struct.new(:rules)
  DELETION_NUMBER = 1

  def initialize(rules)
    super(rules.cycle)
  end

  def applies_to?(string)
    string.length >= DELETION_NUMBER
  end

  def next_string(string)
    follow_next_rule(string).slice(DELETION_NUMBER..-1)
  end

  def follow_next_rule(string)
    rule = rules.next

    if rule.applies_to?(string)
      rule.follow(string)
    else
      string
    end
  end
end
