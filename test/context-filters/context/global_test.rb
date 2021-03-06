=begin
Copyright 2014 Michal Papis <mpapis@gmail.com>

See the file LICENSE for copying permission.
=end

require "test_helper"
require "context-filters/context/global"
require "context-filters/filter_test_subject"

describe ContextFilters::Context::Global do

  subject do
    Object.new.tap { |o| o.extend(ContextFilters::Context::Global) }
  end

  let(:filter_test_subject) do
    FilterTestSubject.new(3)
  end

  it "does not apply filters when no filters" do
    subject.priority_filters.expects(:apply).never
    subject.evaluate_filters(filter_test_subject, :change)
  end

  it "does apply filters" do
    method = Proc.new{}
    subject.context_stack << :a
    subject.filter(nil, :b) { true }
    subject.priority_filters.to_a[0][1].expects(:apply).once.with(filter_test_subject, :change, nil)
    subject.priority_filters.to_a[0][1].expects(:apply).once.with(filter_test_subject, :change, :a)
    subject.evaluate_filters(filter_test_subject, :change)
  end

  it "does apply targeted filters in top context" do
    addition       = Proc.new { |value| value+1 }
    multiplication = Proc.new { |value| value*3 }
    subject.filter(nil, {:target => filter_test_subject}, &addition)
    subject.filter(nil, {:target => nil}, &multiplication)
    subject.evaluate_filters(filter_test_subject, :change)
    filter_test_subject.value.must_equal(4)
  end

  it "does apply targeted filters in sub context" do
    addition       = Proc.new { |value| value+1 }
    multiplication = Proc.new { |value| value*3 }
    subject.context_stack << { :a => 1 }
    subject.filter(nil, {:a => 1, :target => filter_test_subject}, &addition)
    subject.filter(nil, {:a => 1, :target => nil}, &multiplication)
    subject.evaluate_filters(filter_test_subject, :change)
    filter_test_subject.value.must_equal(4)
  end

end
