=begin
Copyright 2014 Michal Papis <mpapis@gmail.com>

See the file LICENSE for copying permission.
=end

require "test_helper"
require "command-designer/global_context"

describe CommandDesigner::GlobalContext do

  subject do
    CommandDesigner::GlobalContext.new
  end

  describe "#initialize" do

    it "sets up initial variables" do
      subject.filters.must_be_kind_of CommandDesigner::Filters
      subject.filters.must_be_empty
      subject.context.must_equal([nil])
    end

  end #initialize

  it "stores filters" do
    subject.filters.expects(:store).with(:a).once
    subject.filter(:a) do true end
  end

  describe "#evaluate_filters" do

    it "does not apply filters when no filters" do
      subject.filters.expects(:apply).never
      subject.evaluate_filters(Proc.new{})
    end

    it "does apply filters" do
      method = Proc.new{}
      subject.context << :a
      subject.filter(:b) { true }
      subject.filters.expects(:apply).once.with(method, nil)
      subject.filters.expects(:apply).once.with(method, :a)
      subject.evaluate_filters(method)
    end

  end #evaluate_command

  describe "#group" do

    it "nests" do
      subject.group(:a) do |test_a|

        test_a.must_be_kind_of CommandDesigner::GlobalContext
        test_a.filters.object_id.must_equal(subject.filters.object_id)
        test_a.context.object_id.wont_equal(subject.context.object_id)
        test_a.context.must_equal([nil, :a])

        test_a.group(:b) do |test_b|
          test_b.must_be_kind_of CommandDesigner::GlobalContext
          test_b.filters.object_id.must_equal(test_a.filters.object_id)
          test_b.context.object_id.wont_equal(test_a.context.object_id)
          test_b.context.must_equal([nil, :a, :b])
        end

        test_a.context.must_equal([nil, :a])
      end
      subject.context.must_equal([nil])
    end

  end #group

end
