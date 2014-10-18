=begin
Copyright 2014 Michal Papis <mpapis@gmail.com>

See the file LICENSE for copying permission.
=end

require "context-filters/priority_filters"

class ContextFilters::Context

  # simple access to global priority filters
  module GlobalFilters

    # @return [PriorityFilters] shared list of filters
    # @api private
    def priority_filters
      @priority_filters ||= initialize_priority_filters(nil)
    end

    # sets up the priorities order for filters
    # @param priority_filters [Array] initialization param for PriorityFilters
    # @api private
    def initialize_priority_filters(priority_filters)
      @priority_filters = ContextFilters::PriorityFilters.new(priority_filters)
    end

    # defines new filter for given +priority+ and +options+
    #
    # @param priority [nil, Object] has to correspond to one of the initialized priorities
    # @param options  [Object]      the options to use for new filter
    # @param block    [Proc]        the transformation to use when the options match
    #
    def filter(priority, options = nil, &block)
      priority_filters.store(priority, options, &block)
    end

  end

end
