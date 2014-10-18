=begin
Copyright 2014 Michal Papis <mpapis@gmail.com>

See the file LICENSE for copying permission.
=end

require "test_helper"
require "context-filters/filters/filters"
require "context-filters/filter_test_subject"

describe ContextFilters::Filters::Filters do

  subject do
    ContextFilters::Filters::Filters.new
  end

  describe "#apply" do

    let(:apply_test_subject) do
      FilterTestSubject.new("test me")
    end

    it "does not apply filter" do
      subject.store({x: 1}) { |value| "better #{value}" }

      subject.apply(apply_test_subject, :change, {x: 2})

      apply_test_subject.value.must_equal("test me")
    end

    it "applies single filter" do
      subject.store({x: 1}) { |value| "better #{value}" }

      subject.apply(apply_test_subject, :change, {x: 1})

      apply_test_subject.value.must_equal("better test me")
    end

    it "applies repeating filters" do
      subject.store({x: 1}) { |value| "better #{value}" }
      subject.store({x: 1}) { |value| "#{value} please" }
      subject.store({x: 1}) { |value| "#{value}!" }

      subject.apply(apply_test_subject, :change, {x: 1})

      apply_test_subject.value.must_equal("better test me please!")
    end

    it "applies different filters" do
      subject.store({x: 1}) { |value| "dont #{value}" }
      subject.store({x: 2}) { |value| "#{value} now" }

      subject.apply(apply_test_subject, :change, {x: 1})
      subject.apply(apply_test_subject, :change, {x: 2})

      apply_test_subject.value.must_equal("dont test me now")
    end

    it "applies only one target filter" do
      subject.store({x: 1, target: apply_test_subject}) { |value| "dont #{value}" }
      subject.store({x: 2, target: nil}) { |value| "#{value} now" }

      subject.apply(apply_test_subject, :change, {x: 1})
      subject.apply(apply_test_subject, :change, {x: 2})

      apply_test_subject.value.must_equal("dont test me")
    end

    it "applies only one target filter by value" do
      subject.store({x: 1, target: "test me"}) { |value| "dont #{value}" }
      subject.store({x: 2, target: nil}) { |value| "#{value} now" }

      subject.apply(apply_test_subject, :change, {x: 1})
      subject.apply(apply_test_subject, :change, {x: 2})

      apply_test_subject.value.must_equal("dont test me")
    end

  end #apply

  describe "#select_filters" do

    let(:apply_test_subject) do
      FilterTestSubject.new("test me")
    end

    it "selects non target filters" do
      change_method1 = Proc.new {}
      change_method2 = Proc.new {}
      subject.store({x: 1}, &change_method1)
      subject.store({x: 2}, &change_method2)
      subject.select_filters(apply_test_subject, {x: 1}).must_equal([change_method1])
    end

    it "selects target filters" do
      change_method1 = Proc.new {}
      change_method2 = Proc.new {}
      subject.store({x: 1, target: apply_test_subject}, &change_method1)
      subject.store({x: 2, target: apply_test_subject}, &change_method2)
      subject.select_filters(apply_test_subject, {x: 2}).must_equal([change_method2])
    end


    it "selects target filters by value" do
      change_method1 = Proc.new {}
      change_method2 = Proc.new {}
      subject.store({x: 1, target: apply_test_subject.initial_value}, &change_method1)
      subject.store({x: 2, target: apply_test_subject.initial_value}, &change_method2)
      subject.select_filters(apply_test_subject, {x: 2}).must_equal([change_method2])
    end

  end #select_filters
end
