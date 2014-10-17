=begin
Copyright 2014 Michal Papis <mpapis@gmail.com>

See the file LICENSE for copying permission.
=end

require "test_helper"
require "context-filters/global_context"
require "context-filters/filter_test_subject"

describe ContextFilters::GlobalContext do

  subject do
    ContextFilters::GlobalContext.new
  end

  let(:filter_test_subject) do
    FilterTestSubject.new(3)
  end

  describe "#initialize" do

    it "sets up initial variables" do
      subject.priority_filters.must_be_kind_of ContextFilters::PriorityFilters
      subject.priority_filters.must_be_empty
      subject.context_stack.must_equal([nil])
    end

  end #initialize

  it "stores filters" do
    subject.priority_filters.expects(:store).with(nil, :a).once
    subject.filter(nil, :a) do true end
  end

  describe "#evaluate_filters" do

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

  end #evaluate_command

  describe "#group" do

    it "nests" do
      subject.context(:a) do |test_a|

        test_a.must_be_kind_of ContextFilters::GlobalContext
        test_a.priority_filters.object_id.must_equal(subject.priority_filters.object_id)
        test_a.context_stack.object_id.wont_equal(subject.context_stack.object_id)
        test_a.context_stack.must_equal([nil, :a])

        test_a.context(:b) do |test_b|
          test_b.must_be_kind_of ContextFilters::GlobalContext
          test_b.priority_filters.object_id.must_equal(test_a.priority_filters.object_id)
          test_b.context_stack.object_id.wont_equal(test_a.context_stack.object_id)
          test_b.context_stack.must_equal([nil, :a, :b])
        end

        test_a.context_stack.must_equal([nil, :a])
      end
      subject.context_stack.must_equal([nil])
    end

  end #group

end
