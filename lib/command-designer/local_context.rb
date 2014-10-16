=begin
Copyright 2014 Michal Papis <mpapis@gmail.com>

See the file LICENSE for copying permission.
=end

require "command-designer/version"

# allow defining local filters and evaluating code in context of thems
module CommandDesigner::LocalContext

  # @returns [Array<Proc>] list of blocks to evaluate
  def local_filters
    @local_filters ||= []
  end

  def local_filter(filter_block, &block)
    local_filters.push(filter_block)
    block.call
  ensure
    local_filters.pop
    nil
  end

  def evaluate_local_filters(method)
    local_filters.each { |block| method.call(&block) }
  end

end
