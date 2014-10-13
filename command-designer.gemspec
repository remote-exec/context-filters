#!/usr/bin/env ruby
# -*- encoding: utf-8 -*-
# stub: ruby-hooks ruby lib

=begin
Copyright 2014 Michal Papis <mpapis@gmail.com>

See the file LICENSE for copying permission.
=end

lib = File.expand_path("../lib/", __FILE__)
$:.unshift lib unless $:.include?(lib)

require "command-designer/version"

Gem::Specification.new do |spec|
  spec.name        = "command-designer"
  spec.version     = ::CommandDesigner::VERSION
  spec.licenses    = ["MIT"]

  spec.authors     = ["Michal Papis"]
  spec.email       = ["mpapis@gmail.com"]

  spec.homepage    = "https://github.com/remote-exec/command-designer"
  spec.summary     = "Build command text based on multiple filters"

  spec.required_ruby_version = ">=1.9.3"

  spec.add_development_dependency("guard",          "~>2.6")
  spec.add_development_dependency("guard-minitest", "~>2.3")
  spec.add_development_dependency("guard-yard",     "~>2.1")
  spec.add_development_dependency("minitest",       "~>5.4")
  spec.add_development_dependency("mocha",          "~>1.1")
  spec.add_development_dependency("rake",           "~>10.3")

  spec.files        = Dir.glob("lib/**/*.rb")
  spec.test_files   = Dir.glob("test/**/*.rb")
end
