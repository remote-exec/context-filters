=begin
Copyright 2014 Michal Papis <mpapis@gmail.com>

See the file LICENSE for copying permission.
=end

require "test_helper"
require "context-filters/filters/priority_filters"

describe ContextFilters::Filters::PriorityFilters do

  subject do
    ContextFilters::Filters::PriorityFilters.allocate
  end

  describe "#initialize" do

    it "initializes with no args" do
      subject.send(:initialize)
      subject.priorities.must_equal([nil])
    end

    it "initializes with objects" do
      subject.send(:initialize, :a)
      subject.priorities.must_equal([:a])
    end

    it "initializes with array" do
      subject.send(:initialize, [:a, nil, :b])
      subject.priorities.must_equal([:a, nil, :b])
    end

    it "initializes to_a" do
      subject.send(:initialize, [:a, :b])
      subject.to_a.size.must_equal(2)
      subject.to_a.map(&:first).must_equal([:a, :b])
      subject.to_a[0][1].must_be_kind_of ContextFilters::Filters::Filters
      subject.to_a[1][1].must_be_kind_of ContextFilters::Filters::Filters
    end

  end #initialize

  describe "#store" do

    it "stores filters" do
      subject.send(:initialize, :a)
      subject.store(:a, :options) {true}
      subject.to_a[0][1].filters.must_equal([:options])
    end

    it "throws exception on wrong priority" do
      subject.send(:initialize, :a)
      lambda {
        subject.store(:b, :options) {true}
      }.must_raise(KeyError)
    end

  end

  it "returns list in to_a" do
    subject.send(:initialize, [2, 1])
    subject.to_a.must_be_kind_of Array
  end

end
