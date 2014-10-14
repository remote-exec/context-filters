=begin
Copyright 2014 Michal Papis <mpapis@gmail.com>

See the file LICENSE for copying permission.
=end

require "command-designer/version"

class CommandDesigner::Filters

  class Filter < Struct(:type, :name, :target, :priority, :transformation)

    def self.from_hash(options, &block)
      self.new(
        options[:type], options[:name], options[:target], options[:priority], &block
      )
    end

    def same(options)
      [ self.priority, self.type, self.name, self.target ] ==
      [ options[:priority], options[:type], options[:name], options[:target] ]
    end

  end

  def initialize
    @filters = []
  end

  def filter(options = {}, &block)
    @filters << Filter.from_hash(options, &block)
  end

  def apply(object, method, options = {})
    select_filters(options).each{|filter| method.call(filter.transformation) }
  end

  def select_filters(options)
    @filters.select(:same, options)
  end

end
