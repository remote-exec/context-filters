=begin
Copyright 2014 Michal Papis <mpapis@gmail.com>

See the file LICENSE for copying permission.
=end

require "context-filters/global_context"
require "context-filters/local_context"

# manipulate set of context and filters for it,
# allow evaluating filters in given context
class ContextFilters::Context < ContextFilters::GlobalContext

  include ContextFilters::LocalContext

  # run the given method on global and local filters
  # @param method [Proc] the method to evaluate for filters matching context
  def evaluate_filters(target, method)
    super(target, method) do
      evaluate_local_filters(target, method)
    end
  end

end
