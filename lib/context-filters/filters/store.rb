=begin
Copyright 2014 Michal Papis <mpapis@gmail.com>

See the file LICENSE for copying permission.
=end

require "context-filters/version"

# filtering related classes and modules
module ContextFilters::Filters

  # Store filters
  module Store

    # @return [Hash] the filters storage
    # @api private
    def filters_store
      @filters_store ||= {}
    end

    # stores the block for given options, if the options have a block
    # already the new one is added to the list
    # @param options [Object] options for filtering blocks
    # @param block   [Proc]   block of code to add to the list of blocks
    #                         for this options
    def store(options = nil, &block)
      filters_store[options] ||= []
      filters_store[options] << block
    end

    # Array of already defined filters
    def filters
      filters_store.keys
    end

    # @return [Boolean] true if there are any rules stored, false otherwise
    def empty?
      filters_store.empty?
    end

  end

end
