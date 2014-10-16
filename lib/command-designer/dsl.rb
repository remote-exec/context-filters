=begin
Copyright 2014 Michal Papis <mpapis@gmail.com>

See the file LICENSE for copying permission.
=end

require "command-designer/command"
require "command-designer/context"

class CommandDesigner::Dsl < CommandDesigner::Context

  def command(command_name)
    cmd = CommandDesigner::Command.new(command_name)
    evaluate_filters(cmd.method(:change))
    cmd.command_name
  end

end
