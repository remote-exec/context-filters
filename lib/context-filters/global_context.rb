=begin
Copyright 2014 Michal Papis <mpapis@gmail.com>

See the file LICENSE for copying permission.
=end

require "context-filters/priority_filters"

# builds list of filters and provides dsl for building nested context
# and allows evaluating filters on methods in the current context
module ContextFilters::GlobalContext

  # @return [Array] the context stack
  # @api private
  def context_stack
    @context_stack ||= [nil]
  end

  # @return [PriorityFilters] shared list of filters
  # @api private
  def priority_filters
    @priority_filters ||= initialize_priority_filters(nil)
  end

  # sets up the priorities order for filters
  # @param priority_filters [Array] initialization param for PriorityFilters
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

  # starts new context
  # @param options [Object] options to start new context
  # @param block   [Proc]   code block that will enable filtering for the given +options+
  # @yield a block in which +context_stack+ temporarily includes +filter_block+
  # @yieldparam    [self]   use it optionally to give a new name to the
  #                         code evaluated in new context
  def context(options, &block)
    context_stack.push(options)
    yield(self)
  ensure
    context_stack.pop
  end

  # evaluates all matching filters for given context_stack, allows to do extra
  # work for +priority.nil?+ or on the end of the priorities,
  #
  # @param method [Proc] the method to evaluate with filters matching current context
  # @yield on first +priority.nil?+ or on the end when none
  def evaluate_filters(target, method)
    local_called = false

    priority_filters.each do |priority, filters|

      context_stack.each { |options| filters.apply(target, method, options) }

      if priority.nil? && block_given? && !local_called
        yield
        local_called = true
      end

    end

    yield if block_given? && !local_called
  end

end
