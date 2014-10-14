# Command Designer

[![Gem Version](https://badge.fury.io/rb/command-designer.png)](https://rubygems.org/gems/command-designer)
[![Build Status](https://secure.travis-ci.org/remote-exec/command-designer.png?branch=master)](https://travis-ci.org/remote-exec/command-designer)
[![Dependency Status](https://gemnasium.com/remote-exec/command-designer.png)](https://gemnasium.com/remote-exec/command-designer)
[![Code Climate](https://codeclimate.com/github/remote-exec/command-designer.png)](https://codeclimate.com/github/remote-exec/command-designer)
[![Coverage Status](https://img.shields.io/coveralls/remote-exec/command-designer.svg)](https://coveralls.io/r/remote-exec/command-designer?branch=master)
[![Inline docs](http://inch-ci.org/github/remote-exec/command-designer.png)](http://inch-ci.org/github/remote-exec/command-designer)
[![Yard Docs](http://img.shields.io/badge/yard-docs-blue.svg)](http://rubydoc.info/github/remote-exec/command-designer/master/frames)
[![Github Code](http://img.shields.io/badge/github-code-blue.svg)](https://github.com/remote-exec/command-designer)

Build command text based on multiple filters

## Content

This gem contains two helper classes that are not connected but fully
compatible, you can use them together to allow building advanced
commands using filters (like server / server group).

## Command

`CommandDesigner::Command` is a simple implementation with string value -
the `command_name` and a callback function allowing to change it.

## Filters

`CommandDesigner::Filters` allows storing and applying filters,
the filters can be anything, most convienient an object instance or
hash of options.
