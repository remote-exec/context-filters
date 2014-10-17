# Context Filters

[![Gem Version](https://badge.fury.io/rb/context-filters.png)](https://rubygems.org/gems/context-filters)
[![Build Status](https://secure.travis-ci.org/remote-exec/context-filters.png?branch=master)](https://travis-ci.org/remote-exec/context-filters)
[![Dependency Status](https://gemnasium.com/remote-exec/context-filters.png)](https://gemnasium.com/remote-exec/context-filters)
[![Code Climate](https://codeclimate.com/github/remote-exec/context-filters.png)](https://codeclimate.com/github/remote-exec/context-filters)
[![Coverage Status](https://img.shields.io/coveralls/remote-exec/context-filters.svg)](https://coveralls.io/r/remote-exec/context-filters?branch=master)
[![Inline docs](http://inch-ci.org/github/remote-exec/context-filters.png)](http://inch-ci.org/github/remote-exec/context-filters)
[![Yard Docs](http://img.shields.io/badge/yard-docs-blue.svg)](http://rubydoc.info/github/remote-exec/context-filters/master/frames)
[![Github Code](http://img.shields.io/badge/github-code-blue.svg)](https://github.com/remote-exec/context-filters)

Generic support for filters applied in context

## About

This is a set of classes (framework) to build context aware filtering
system, allows:

1. nested context
2. global filters applied depending on context
3. local filters applied in given scope
4. priority based applying of global filters with mixed in local filtering
5. no assumptions in the usage or context/filter format

## ContextFilters::Context

This is the main class, it provides DSL methods to build nestable
context, global and local filters and to execute filters depending on
context.

### DSL Methods

- `initialize(priorities_array)` - sets up initial context (+nil+),
  execute all methods on this instance
- `filter(priority, options) { code }` - create priority based filter
  for given options with the code bloc to execute
- `local_filter(filter_block) { code }` - define local `filter_block` to
  take effect for the given `code` block, it's tricky as it takes two
  lambdas, try: `local_filter(Proc.new{|cmd| "cd path && #{cmd}"}) { code }`
- `context(options) { code }` - build new context, options are for
  matching filters, all code will be executes in context of given options
- `evaluate_filters(target, method)` - evaluate global and local filters
  in the order of given priority, local filters are called after the `nil`
  priority, try priorities: `[:first, nil, :last]`

### Example

On The beginning we need object that can apply multiple filters on
itself, we will use the method `change` for that:
```ruby
# test/context-filters/filter_test_subject.rb
class FilterTestSubject
  attr_accessor :value
  def initialize(value)
    @value = value
  end
  def change(&block)
    @value = block.call(@value)
  end
end
```

The method does not have to be called change, you can use any number of
attributes (`@a1, @a2... = block.call(@a1, @a2...)`) or pass `self`
(`block.call(self)`).

Now the real example:

```ruby
# define filter that adds one to our number
addition       = Proc.new { |value| value+1 }
# define filter that multiplies our number by three
multiplication = Proc.new { |value| value*3 }

# use the multiplication filter globally (the nil scope is the initial context)
subject.filter(nil,&multiplication)
# use addition filter only in the scope of the given block
subject.local_filter(addition) do

  # usually you would extend Context and provide a helper method to do the following:
  # build the object we want to filter
  filter_test_subject = FilterTestSubject.new(3)
  # apply matching filters to the object
  subject.evaluate_filters(filter_test_subject, :change)
  # get the result from object
  puts filter_test_subject.value
  # => 10

end
```

This should be it, for real life example check:

- https://github.com/remote-exec/command-designer
