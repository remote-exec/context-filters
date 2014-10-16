=begin
Copyright 2014 Michal Papis <mpapis@gmail.com>

See the file LICENSE for copying permission.
=end

require "test_helper"
require "command-designer/priority_filters"

describe CommandDesigner::PriorityFilters do

  subject do
    CommandDesigner::PriorityFilters.allocate
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

    it "initializes filters_hash" do
      subject.send(:initialize, [:a, :b])
      subject.filters_hash.size.must_equal(2)
      subject.filters_hash.keys.must_equal([:a, :b])
      subject.filters_hash.values[0].must_be_kind_of CommandDesigner::Filters
      subject.filters_hash.values[1].must_be_kind_of CommandDesigner::Filters
    end

  end #initialize

  describe "#store" do

    it "stores filters" do
      subject.send(:initialize, :a)
      subject.store(:a, :options) {true}
      subject.filters_hash.values[0].filters.must_equal([:options])
    end

    it "throws exception on wrong priority" do
      subject.send(:initialize, :a)
      lambda {
        subject.store(:b, :options) {true}
      }.must_raise(KeyError)
    end

  end

  it "sorts list in to_a" do
    subject.send(:initialize, [2, 1])
    subject.to_a.map(&:object_id).must_equal(subject.filters_hash.each_pair.sort.map{|key, value| value.object_id})
  end

end
