=begin
Copyright 2014 Michal Papis <mpapis@gmail.com>

See the file LICENSE for copying permission.
=end

require "command-designer/priority_filters"

class CommandDesigner::GlobalContext

  attr_reader :context
  attr_reader :priority_filters

  def initialize(priority_filters = nil, context = [], options = nil)
    case priority_filters
    when Array, nil then @priority_filters = CommandDesigner::PriorityFilters.new(priority_filters)
    else @priority_filters = priority_filters
    end
    @context = context.dup + [options]
  end

  def filter(priority, options = nil, &block)
    @priority_filters.store(priority, options, &block)
  end

  def in_context(options, &block)
    self.class.new(@priority_filters, @context, options).tap(&block)
  end

  def evaluate_filters(method)
    local_called = false

    @priority_filters.each do |priority, filters|

      @context.each { |options| filters.apply(method, options) }

      if priority.nil? && block_given? && !local_called
        yield
        local_called = true
      end

    end

    yield if block_given? && !local_called
  end

end
