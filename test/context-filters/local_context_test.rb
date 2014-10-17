=begin
Copyright 2014 Michal Papis <mpapis@gmail.com>

See the file LICENSE for copying permission.
=end

require "test_helper"
require "context-filters/local_context"
require "context-filters/filter_test_subject"

describe ContextFilters::LocalContext do

  subject do
    Object.new.tap { |o| o.extend(ContextFilters::LocalContext) }
  end

  let(:filter_test_subject) do
    FilterTestSubject.new(3)
  end

  it "has default value for #local_filters" do
    subject.local_filters.must_equal([])
  end

  it "adds local filters" do
    change_method = Proc.new {}
    subject.local_filter(change_method) do
      subject.local_filters.must_equal([change_method])
    end
    subject.local_filters.must_equal([])
  end

  it "runs change" do
    method = Proc.new { |value| value+4 }
    subject.stubs(:local_filters).returns([method])
    subject.evaluate_local_filters(filter_test_subject, :change)
    filter_test_subject.value.must_equal(7)
  end

end
