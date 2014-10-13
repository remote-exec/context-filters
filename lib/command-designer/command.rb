=begin
Copyright 2014 Michal Papis <mpapis@gmail.com>

See the file LICENSE for copying permission.
=end

require "command-designer/version"

class CommandDesigner::Command

  attr_reader :command_name, :initial_command_name

  def initialize(command_name)
    @command_name = command_name
    @initial_command_name = command_name
  end

  def reset
    @command_name = @initial_command_name
  end

  def with(&block)
    @command_name = yield @command_name
  end

end
