=begin
Copyright 2014 Michal Papis <mpapis@gmail.com>

See the file LICENSE for copying permission.
=end

module CommandDesigner::LocalContext

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
    local_filters.each { |filter| filter.call(method) }
  end

end
