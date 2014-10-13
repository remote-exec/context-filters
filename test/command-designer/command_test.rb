=begin
Copyright 2014 Michal Papis <mpapis@gmail.com>

See the file LICENSE for copying permission.
=end

require "test_helper"
require "command-designer/command"

describe CommandDesigner::Command do
  subject do
    CommandDesigner::Command.allocate
  end

  it "initializes command" do
    subject.send(:initialize, "true")
    subject.command_name.must_equal("true")
    subject.initial_command_name.must_equal("true")
  end

  it "builds and resets the command" do
    subject.send(:initialize, "true")
    subject.with {|command| "env #{command}"}
    subject.command_name.must_equal("env true")
    subject.reset
    subject.command_name.must_equal("true")
  end

end
