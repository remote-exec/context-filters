=begin
Copyright 2014 Michal Papis <mpapis@gmail.com>

See the file LICENSE for copying permission.
=end

require "command-designer/filters"

# list of +filters+ sorted by +priorities+
class CommandDesigner::PriorityFilters

  # list of priorities for ordering objects
  attr_reader :priorities

  # internal list of filters
  # @api private
  attr_reader :filters_hash

  # initializes priorities and coresponding list of filters
  # @param priorities [Array] a list of priorities to order filters
  def initialize(priorities = nil)
    @priorities   = [priorities].flatten
    @filters_hash = Hash[@priorities.product([CommandDesigner::Filters.new])]
  end

  # adds a priority filter
  #
  # @param priority [Object]   anything that was part of +priorities+ array
  # @param options  [Object]   forwarded to Filters.store
  # @param block    [Proc]     forwarded to Filters.store
  # @raises         [KeyError] when priority not matching priorities is used
  def store(priority, options = nil, &block)
    @filters_hash.fetch(priority).store(options, &block)
  end

  # list of +filters+ sorted by +priorities+
  def to_a
    @filters_hash.values_at(*priorities)
  end

  # iterate over +filters+ ordered by +priority+
  # @yields [Filters] the next filters from sorted array
  def each(&block)
    to_a.each(&block)
  end

  # check if all of the filters are empty
  # returns [Bolean] true if all filters are empty
  def empty?
    @filters_hash.values.all?(&:empty?)
  end

end
