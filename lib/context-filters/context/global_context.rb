=begin
Copyright 2014 Michal Papis <mpapis@gmail.com>

See the file LICENSE for copying permission.
=end

require "context-filters/version"

class ContextFilters::Context

  # temporarily stack context and yield code
  module GlobalContext

    # @return [Array] the context stack
    # @api private
    def context_stack
      @context_stack ||= [nil]
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
  end

end
