=begin
Copyright 2014 Michal Papis <mpapis@gmail.com>

See the file LICENSE for copying permission.
=end

require "test_helper"
require "context-filters/context/global_filters"

describe ContextFilters::Context::GlobalFilters do

  subject do
    Object.new.tap { |o| o.extend(ContextFilters::Context::GlobalFilters) }
  end

  it "sets up empty initial variables" do
    subject.priority_filters.must_be_kind_of ContextFilters::PriorityFilters
    subject.priority_filters.must_be_empty
  end

  it "initializes new PriorityFilters" do
    example = [:a, :b, :c]
    subject.initialize_priority_filters(example)
    subject.priority_filters.priorities.must_equal(example)
  end

  it "stores filters" do
    subject.priority_filters.expects(:store).with(nil, :a).once
    subject.filter(nil, :a) do true end
  end

end
