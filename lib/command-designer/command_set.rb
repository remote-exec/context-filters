=begin
Copyright 2014 Michal Papis <mpapis@gmail.com>

See the file LICENSE for copying permission.
=end

require "command-designer/command"
require "command-designer/filters"

class CommandDesigner::CommandSet

  attr_reader :commands
  attr_reader :filters

  def initialize
    @commands = {}
    @filters  = CommandDesigner::Filters.new
  end

end
