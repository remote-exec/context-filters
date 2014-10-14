=begin
Copyright 2014 Michal Papis <mpapis@gmail.com>

See the file LICENSE for copying permission.
=end

require "command-designer/version"

# Store and apply filters using blocks
class CommandDesigner::Filters

  # @api private
  # @return [Hash<Hash,[Proc...]>] stores array of blocks for filter
  attr_reader :filters

  def initialize
    @filters = {}
  end

  def store(options = {}, &block)
    @filters[options] ||= []
    @filters[options] << block
  end

  def apply(method, options = {})
    @filters.fetch(options, []).each{|block| method.call(&block) }
  end

end
