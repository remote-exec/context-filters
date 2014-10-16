=begin
Copyright 2014 Michal Papis <mpapis@gmail.com>

See the file LICENSE for copying permission.
=end

class FilterTestSubject
  attr_reader :value
  def initialize(value)
    @value = value
  end
  def change(&block)
    @value = block.call(@value)
  end
end
