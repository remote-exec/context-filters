=begin
Copyright 2014 Michal Papis <mpapis@gmail.com>

See the file LICENSE for copying permission.
=end

require "test_helper"
require "context-filters/context"
require "context-filters/filter_test_subject"

describe ContextFilters::Context do

  subject do
    ContextFilters::Context.new
  end

  let(:filter_test_subject) do
    FilterTestSubject.new(3)
  end

  describe "#evaluate_filters" do

    it "does not apply filters when no filters" do
      subject.priority_filters.expects(:apply).never
      subject.evaluate_filters(filter_test_subject, :change)
    end

    it "does apply global filters" do
      subject.context_stack << :a
      subject.filter(nil, :b) { true }
      subject.priority_filters.to_a[0][1].expects(:apply).once.with(filter_test_subject, :change, nil)
      subject.priority_filters.to_a[0][1].expects(:apply).once.with(filter_test_subject, :change, :a)
      subject.evaluate_filters(filter_test_subject, :change)
    end

    it "does apply local filters" do
      subject.stubs(:local_filters).returns([Proc.new{|value| value+4}])
      subject.evaluate_filters(filter_test_subject, :change)
      filter_test_subject.value.must_equal(7)
    end

    it "does apple global and local filters" do
      filter_test_subject.value.must_equal(3)
      addition       = Proc.new { |value| value+1 }
      multiplication = Proc.new { |value| value*3 }

      subject.filter(nil,&multiplication)
      subject.local_filter(addition) do
        subject.evaluate_filters(filter_test_subject, :change)
      end

      filter_test_subject.value.must_equal(10)
    end

  end #evaluate_command

end
