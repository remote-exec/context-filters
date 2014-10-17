=begin
Copyright 2014 Michal Papis <mpapis@gmail.com>

See the file LICENSE for copying permission.
=end

class FilterTestSubject
  attr_accessor :value, :initial_value
  def initialize(value)
    @value = value
    @initial_value = value
  end
  def change(&block)
    @value = block.call(@value)
  end
  def ==(other)
    if self.class === other
    then self.initial_value == other.initial_value
    else self.initial_value == other
    end
  end
end
