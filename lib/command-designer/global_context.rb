=begin
Copyright 2014 Michal Papis <mpapis@gmail.com>

See the file LICENSE for copying permission.
=end

require "command-designer/filters"

class CommandDesigner::GlobalContext

  attr_reader :context
  attr_reader :global_filters

  def initialize(global_filters = nil, context = [], options = nil)
    @global_filters = global_filters || CommandDesigner::Filters.new
    @context = context.dup + [options]
  end

  def global_filter(options = nil, &block)
    @global_filters.store(options, &block)
  end

  def group(options, &block)
    self.class.new(@global_filters, @context, options).tap(&block)
  end

  def evaluate_filters(method)
    @context.each do |options|
      @global_filters.apply(method, options)
    end unless @global_filters.empty?
  end

end
