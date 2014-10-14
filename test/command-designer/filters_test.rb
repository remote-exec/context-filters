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
      subject.filter do true end
      subject.filters.size.must_equal 1
      subject.filters.first.first.must_equal({})
    end

    it "adds options filter" do
      subject.filter x: 2 do true end
      subject.filters.size.must_equal 1
      subject.filters.first.first.must_equal({x:2})
    end

    it "adds hash filter" do
      subject.filter({x: 3}) { true }
      subject.filters.size.must_equal 1
      subject.filters.first.first.must_equal({x:3})
    end

    it "adds nil filter" do
      subject.filter(nil) { true }
      subject.filters.size.must_equal 1
      subject.filters.first.first.must_equal(nil)
    end

    it "adds filter block" do
      subject.filter do 4 end
      subject.filters.size.must_equal 1
      subject.filters.first.last.call.must_equal(4)
    end

  end #filter

  describe "#select_filters" do

    before do
      subject.filter(nil)    { true  }
      subject.filter({})     { true  }
      subject.filter({x: 1}) { true  }
      subject.filter({y: 2}) { true  }
      subject.filter({y: 2}) { false }
    end

    it "finds nil filter" do
      subject.select_filters(nil).must_equal([subject.filters[0]])
    end

    it "finds empty filter" do
      subject.select_filters({}).must_equal([subject.filters[1]])
    end

    it "finds single filter" do
      subject.select_filters({x: 1}).must_equal([subject.filters[2]])
    end

    it "finds multiple filters" do
      subject.select_filters({y: 2}).must_equal(subject.filters[3..4])
    end

  end #select_filters

  describe "#apply" do

    let(:apply_test_subject) do
      FiltersTestSubject.new("test me")
    end

    it "does not apply filter" do
      subject.filter({x: 1}) { |value| "better #{value}" }

      subject.apply(apply_test_subject.method(:change), {x: 2})

      apply_test_subject.value.must_equal("test me")
    end

    it "applies single filter" do
      subject.filter({x: 1}) { |value| "better #{value}" }

      subject.apply(apply_test_subject.method(:change), {x: 1})

      apply_test_subject.value.must_equal("better test me")
    end

    it "applies repeating filters" do
      subject.filter({x: 1}) { |value| "better #{value}" }
      subject.filter({x: 1}) { |value| "#{value} please" }
      subject.filter({x: 1}) { |value| "#{value}!" }

      subject.apply(apply_test_subject.method(:change), {x: 1})

      apply_test_subject.value.must_equal("better test me please!")
    end

    it "applies different filters" do
      subject.filter({x: 1}) { |value| "dont #{value}" }
      subject.filter({x: 2}) { |value| "#{value} now" }

      subject.apply(apply_test_subject.method(:change), {x: 1})
      subject.apply(apply_test_subject.method(:change), {x: 2})

      apply_test_subject.value.must_equal("dont test me now")
    end

  end #apply

end
