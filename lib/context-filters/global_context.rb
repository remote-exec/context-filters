=begin
Copyright 2014 Michal Papis <mpapis@gmail.com>

See the file LICENSE for copying permission.
=end

require "context-filters/priority_filters"

# builds list of filters and provides dsl for building nested context
# and allows evaluating filters on methods in the current context
class ContextFilters::GlobalContext

  # @return [Array] the context stack
  # @api private
  attr_reader :context

  # @return [PriorityFilters] shared list of filters
  # @api private
  attr_reader :priority_filters

  # initialize new GlobalContext, works in two modes:
  # 1. start totally new context, takes one param - array of priorities,
  #    +nil+ to use one anonymous priority
  # 2. build sub context, params: global_filters_list, parents_context,
  #    value to add to context
  #
  # @param priority_filters [Array,PriorityFilters] when PriorityFilters - uses it for priority_filters
  #                                                 otherwise - initializes new priority_filters with it
  # @param context [Array]  parents context, duplicates to initialize own context
  # @param options [Object] new context, ads it to current context
  #
  def initialize(priority_filters = nil, context = [], options = nil)
    if ContextFilters::PriorityFilters === priority_filters
    then @priority_filters = priority_filters
    else @priority_filters = ContextFilters::PriorityFilters.new(priority_filters)
    end
    @context = context.dup + [options]
  end

  # defines new filter for given +priority+ and +options+
  #
  # @param priority [nil, Object] has to correspond to one of the initialized priorities
  # @param options  [Object]      the options to use for new filter
  # @param block    [Proc]        the transformation to use when the options match
  #
  def filter(priority, options = nil, &block)
    @priority_filters.store(priority, options, &block)
  end

  # starts new context
  # @param options [Object] options to start new context
  # @param block   [Proc]   code block that will enable filtering for the given +options+
  # @yield         [GlobalContext] the new context
  def in_context(options, &block)
    self.class.new(@priority_filters, @context, options).tap(&block)
  end

  # evaluates all matching filters for given context, allows to do extra
  # work for +priority.nil?+ or on the end of the priorities,
  # @param method [Proc] the method to evaluate with filters matching current context
  # @yield on first +priority.nil?+ or on the end when none
  def evaluate_filters(method)
    local_called = false

    @priority_filters.each do |priority, filters|

      @context.each { |options| filters.apply(method, options) }

      if priority.nil? && block_given? && !local_called
        yield
        local_called = true
      end

    end

    yield if block_given? && !local_called
  end

end
