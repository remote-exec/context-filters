=begin
Copyright 2014 Michal Papis <mpapis@gmail.com>

See the file LICENSE for copying permission.
=end

require "test_helper"
require "command-designer/context"
require "command-designer/filter_test_subject"

describe CommandDesigner::Context do

  subject do
    CommandDesigner::Context.new
  end

  let(:filter_test_subject) do
    FilterTestSubject.new(3)
  end

  let(:change_method) do
    filter_test_subject.method(:change)
  end

  describe "#evaluate_filters" do

    it "does not apply filters when no filters" do
      subject.filters.expects(:apply).never
      subject.evaluate_filters(Proc.new{})
    end

    it "does apply global filters" do
      method = Proc.new{}
      subject.context << :a
      subject.filter(:b) { true }
      subject.filters.expects(:apply).once.with(method, nil)
      subject.filters.expects(:apply).once.with(method, :a)
      subject.evaluate_filters(method)
    end

    it "does apply local filters" do
      subject.stubs(:local_filters).returns([change_method])
      subject.evaluate_filters(Proc.new{|value| value+4})
      filter_test_subject.value.must_equal(7)
    end

    it "does apple global and local filters" do
      method = Proc.new { |value| value+4 }
      subject.stubs(:local_filters).returns([change_method])
      subject.filter(:b) { true }
      subject.filters.expects(:apply).once.with(method, nil)
      subject.evaluate_filters(method)
      filter_test_subject.value.must_equal(7)
    end

  end #evaluate_command

end
