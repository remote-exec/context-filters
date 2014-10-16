=begin
Copyright 2014 Michal Papis <mpapis@gmail.com>

See the file LICENSE for copying permission.
=end

require "test_helper"
require "command-designer/local_context"
require "command-designer/filter_test_subject"

describe CommandDesigner::LocalContext do

  subject do
    Object.new.tap { |o| o.extend(CommandDesigner::LocalContext) }
  end

  let(:filter_test_subject) do
    FilterTestSubject.new(3)
  end

  let(:change_method) do
    filter_test_subject.method(:change)
  end

  it "has default value for #local_filters" do
    subject.local_filters.must_equal([])
  end

  it "adds local filters" do
    subject.local_filter(change_method) do
      subject.local_filters.must_equal([change_method])
    end
    subject.local_filters.must_equal([])
  end

  it "runs change" do
    method = Proc.new { |value| value+4 }
    subject.stubs(:local_filters).returns([change_method])
    subject.evaluate_local_filters(method)
    filter_test_subject.value.must_equal(7)
  end

end
