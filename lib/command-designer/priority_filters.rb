=begin
Copyright 2014 Michal Papis <mpapis@gmail.com>

See the file LICENSE for copying permission.
=end

require "command-designer/filters"

# list of +filters+ sorted by +priorities+
class CommandDesigner::PriorityFilters

  attr_reader :priorities

  # initializes priorities and coresponding list of filters
  # @param priorities [Array|Object] a list of priorities to order filters
  def initialize(priorities = nil)
    @priorities = [priorities].flatten.freeze
    @filters_array = @priorities.product([CommandDesigner::Filters.new])
  end

  # adds a priority filter
  #
  # @param priority [Object]   anything that was part of +priorities+ array
  # @param options  [Object]   forwarded to Filters.store
  # @param block    [Proc]     forwarded to Filters.store
  # @raise          [KeyError] when priority not matching priorities is used
  def store(priority, options = nil, &block)
    found = @filters_array.assoc(priority)
    raise KeyError if found.nil?
    found.last.store(options, &block)
  end

  # list of +filters+ sorted by +priorities+
  def to_a
    @filters_array
  end

  # iterate over +filters+ ordered by +priority+
  # @yield [priority,filters] the next filters from sorted array
  # @yieldparam priority [Object]  the priority
  # @yieldparam filters  [Filters] the filters for priority
  def each(&block)
    to_a.each(&block) unless empty?
  end

  # check if all of the filters are empty
  # return [Bolean] true if all filters are empty
  def empty?
    @filters_array.map(&:last).all?(&:empty?)
  end

end
