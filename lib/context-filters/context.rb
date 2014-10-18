=begin
Copyright 2014 Michal Papis <mpapis@gmail.com>

See the file LICENSE for copying permission.
=end

require "context-filters/context/global"
require "context-filters/context/local"

# manipulate set of context and filters for it,
# allow evaluating filters in given context
class ContextFilters::Context

  include ContextFilters::Context::Global
  include ContextFilters::Context::Local

  # sets up the priorities order for global context filters
  # @param priority_filters [Array] initialization param for PriorityFilters
  def initialize(priority_filters = nil)
    initialize_priority_filters(priority_filters)
  end

  # run the given method on global and local filters
  # @param method [Proc] the method to evaluate for filters matching context
  def evaluate_filters(target, method)
    super(target, method) do
      evaluate_local_filters(target, method)
    end
  end

end
