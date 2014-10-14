=begin
Copyright 2014 Michal Papis <mpapis@gmail.com>

See the file LICENSE for copying permission.
=end

require "command-designer/version"

class CommandDesigner::Filters

  def initialize
    @filters = []
  end

  def filter(options = {}, &block)
    @filters << [ options, &block ]
  end

  def apply(object, method, options = {})
    select_filters(options).each{|filter, block| method.call(block) }
  end

  def select_filters(options)
    @filters.select { |filter, block| filter == options }
  end

end
