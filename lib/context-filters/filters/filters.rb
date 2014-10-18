=begin
Copyright 2014 Michal Papis <mpapis@gmail.com>

See the file LICENSE for copying permission.
=end

require "context-filters/filters/store"

# filtering related classes and modules
module ContextFilters::Filters

  # Store and apply filters using blocks
  #
  # @example
  #
  #   class FiltersTestSubject
  #     attr_reader :value
  #     def initialize(value)
  #       @value = value
  #     end
  #     def change(&block)
  #       @value = block.call(@value)
  #     end
  #   end
  #   filters = ContextFilters::Filters.new
  #   filters.store(:addition) {|value| value + 1 }
  #   filters.store(:subtraction) {|value| value - 1 }
  #   filters.filters # => [:addition, :subtraction]
  #   object = FiltersTestSubject.new(3)
  #   object.value => 3
  #   filters.apply(object.method(:change), :addition)
  #   object.value => 4
  #   filters.apply(object.method(:change), :subtraction)
  #   object.value => 3

  class Filters

    include Store

    # applies matching filters to the given target method, also uses
    # filters matching extra +:target => target+ when options is a Hash
    # @param target  [Object] an object to run the method on
    # @param method  [symbol] method name that takes a transformation
    #                         block as param
    # @param options [Object] a filter for selecting matching blocks
    def apply(target, method, options = nil)
      select_filters(target, options).each{|block| target.send(method, &block) }
    end

    # Select matching filters and filters including targets when
    # options is a +Hash+
    # @param target  [Object] an object to run the method on
    # @param options [Object] a filter for selecting matching blocks
    def select_filters(target, options)
      found = filters_store.fetch(options, [])
      if
        Hash === options || options.nil?
      then
        options ||={}
        options.merge!(:target => target)
        found +=
        # can not @filters.fetch(options, []) to allow filters provide custom ==()
        filters_store.select do |filter_options, filters|
          options == filter_options
        end.map(&:last).flatten
      end
      found
    end

  end

end
