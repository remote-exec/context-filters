=begin
Copyright 2014 Michal Papis <mpapis@gmail.com>

See the file LICENSE for copying permission.
=end

require "test_helper"
require "context-filters/context/global_context"

describe ContextFilters::Context::GlobalContext do

  subject do
    Object.new.tap { |o| o.extend(ContextFilters::Context::GlobalContext) }
  end

  it "sets up initial variables" do
    subject.context_stack.must_equal([nil])
  end

  it "nests context" do
    subject.context(:a) do |test_a|

      test_a.object_id.must_equal(subject.object_id)
      test_a.context_stack.must_equal([nil, :a])

      test_a.context(:b) do |test_b|
        test_b.object_id.must_equal(test_a.object_id)
        test_b.context_stack.must_equal([nil, :a, :b])
      end

      test_a.context_stack.must_equal([nil, :a])
    end
    subject.context_stack.must_equal([nil])
  end

end
