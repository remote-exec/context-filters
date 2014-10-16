=begin
Copyright 2014 Michal Papis <mpapis@gmail.com>

See the file LICENSE for copying permission.
=end

require "command-designer/version"

# allow defining local filters and evaluating code in context of thems
module CommandDesigner::LocalContext

  # @return [Array<Proc>] list of blocks to evaluate
  def local_filters
    @local_filters ||= []
  end

  # temporarly adds +filter_block+ to the list of filters to run and
  # yields given block of code
  #
  # @param filter_block [Proc] a block of code to add to the list
  # @yield a block in which +local_filters+ temporarly includes
  #         +filter_block+
  def local_filter(filter_block, &block)
    local_filters.push(filter_block)
    block.call
  ensure
    local_filters.pop
    nil
  end

  # iterates over +local_filters+ and applies them to the given +method+
  #
  # @param method [Proc] a method to call with each filter stored in
  #                      +local_filters+
  def evaluate_local_filters(method)
    local_filters.each { |block| method.call(&block) }
  end

end
