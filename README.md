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

## Filters

`CommandDesigner::Filters` allows storing and applying filters,
the filters can be anything, most convienient an object instance or
hash of options.

