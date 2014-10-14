=begin
Copyright 2014 Michal Papis <mpapis@gmail.com>

See the file LICENSE for copying permission.
=end

require "test_helper"
require "command-designer/filters"

class FiltersTestSubject
  attr_reader :value
  def initialize(value)
    @value = value
  end
  def change(&block)
    @value = block.call(@value)
  end
end

describe CommandDesigner::Filters do

  subject do
    CommandDesigner::Filters.new
  end

  describe "#filter" do

    it "adds empty filter" do
      subject.store() { true }
      subject.filters.size.must_equal 1
      subject.filters.first.first.must_equal({})
    end

    it "adds options filter" do
      subject.store(x: 2) { true }
      subject.filters.size.must_equal 1
      subject.filters.first.first.must_equal({x:2})
    end

    it "adds hash filter" do
      subject.store({x: 3}) { true }
      subject.filters.size.must_equal 1
      subject.filters.first.first.must_equal({x:3})
    end

    it "adds nil filter" do
      subject.store(nil) { true }
      subject.filters.size.must_equal 1
      subject.filters.first.first.must_equal(nil)
    end

    it "adds filter block" do
      subject.store() { 4 }
      subject.filters.size.must_equal 1
      subject.filters[{}].size.must_equal 1
      subject.filters[{}].first.call.must_equal(4)
    end

  end #filter

  describe "#apply" do

    let(:apply_test_subject) do
      FiltersTestSubject.new("test me")
    end

    it "does not apply filter" do
      subject.store({x: 1}) { |value| "better #{value}" }

      subject.apply(apply_test_subject.method(:change), {x: 2})

      apply_test_subject.value.must_equal("test me")
    end

    it "applies single filter" do
      subject.store({x: 1}) { |value| "better #{value}" }

      subject.apply(apply_test_subject.method(:change), {x: 1})

      apply_test_subject.value.must_equal("better test me")
    end

    it "applies repeating filters" do
      subject.store({x: 1}) { |value| "better #{value}" }
      subject.store({x: 1}) { |value| "#{value} please" }
      subject.store({x: 1}) { |value| "#{value}!" }

      subject.apply(apply_test_subject.method(:change), {x: 1})

      apply_test_subject.value.must_equal("better test me please!")
    end

    it "applies different filters" do
      subject.store({x: 1}) { |value| "dont #{value}" }
      subject.store({x: 2}) { |value| "#{value} now" }

      subject.apply(apply_test_subject.method(:change), {x: 1})
      subject.apply(apply_test_subject.method(:change), {x: 2})

      apply_test_subject.value.must_equal("dont test me now")
    end

  end #apply

end
