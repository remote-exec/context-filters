=begin
Copyright 2014 Michal Papis <mpapis@gmail.com>

See the file LICENSE for copying permission.
=end

require "command-designer/filters"

class CommandDesigner::GlobalContext

  attr_reader :context
  attr_reader :filters

  def initialize(filters = nil, context = [], options = nil)
    @filters = filters || CommandDesigner::Filters.new
    @context = context.dup + [options]
  end

  def filter(options = nil, &block)
    @filters.store(options, &block)
  end

  def in_context(options, &block)
    self.class.new(@filters, @context, options).tap(&block)
  end

  def evaluate_filters(method)
    @context.each do |options|
      @filters.apply(method, options)
    end unless @filters.empty?
    yield if block_given?
  end

end
