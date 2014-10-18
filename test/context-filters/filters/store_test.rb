=begin
Copyright 2014 Michal Papis <mpapis@gmail.com>

See the file LICENSE for copying permission.
=end

require "test_helper"
require "context-filters/filters/store"

describe ContextFilters::Filters::Store do

  subject do
    Object.new.tap { |o| o.extend(ContextFilters::Filters::Store) }
  end

  it "adds empty filter" do
    subject.store() { true }
    subject.filters.size.must_equal 1
    subject.filters.first.must_equal(nil)
  end

  it "adds options filter" do
    subject.store(x: 2) { true }
    subject.filters.size.must_equal 1
    subject.filters.first.must_equal({x:2})
  end

  it "adds hash filter" do
    subject.store({x: 3}) { true }
    subject.filters.size.must_equal 1
    subject.filters.first.must_equal({x:3})
  end

  it "adds nil filter" do
    subject.store(nil) { true }
    subject.filters.size.must_equal 1
    subject.filters.first.must_equal(nil)
  end

  it "adds filter block" do
    subject.store() { 4 }
    subject.filters_store.size.must_equal 1
    subject.filters_store[nil].size.must_equal 1
    subject.filters_store[nil].first.call.must_equal(4)
  end

  it "is empty?" do
    subject.filters_store.size.must_equal 0
    subject.empty?.must_equal true
  end

  it "is not empty?" do
    subject.store() { 4 }
    subject.empty?.must_equal false
  end

end
