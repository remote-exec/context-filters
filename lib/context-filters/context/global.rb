=begin
Copyright 2014 Michal Papis <mpapis@gmail.com>

See the file LICENSE for copying permission.
=end

require "context-filters/priority_filters"
require "context-filters/context/global_context"
require "context-filters/context/global_filters"

class ContextFilters::Context

  # builds list of filters and provides dsl for building nested context
  # and allows evaluating filters on methods in the current context
  module Global

    include GlobalContext
    include GlobalFilters

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

end
