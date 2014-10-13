=begin
Copyright 2014 Michal Papis <mpapis@gmail.com>

See the file LICENSE for copying permission.
=end

require "command-designer/version"

# A concpet of command that can be extended multiple times
class CommandDesigner::Command

  # @return [String] current value of the command
  attr_reader :command_name

  # @return [String] initial value of the command
  attr_reader :initial_command_name

  # Set up the instance
  # @param command_name [String] The command name to build upon
  def initialize(command_name)
    @command_name = command_name
    @initial_command_name = command_name
  end

  # reset command to it's initial state
  def reset
    @command_name = @initial_command_name
  end

  # Yields a block to change the command
  # @yields     [command_name] a block to change the command
  # @yieldparam command_name [String] the current command
  # @return     [String] the new command
  def change(&block)
    @command_name = yield @command_name
  end

end
