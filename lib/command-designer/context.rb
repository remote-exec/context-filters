=begin
Copyright 2014 Michal Papis <mpapis@gmail.com>

See the file LICENSE for copying permission.
=end

require "command-designer/global_context"
require "command-designer/local_context"

class CommandDesigner::Context < CommandDesigner::GlobalContext

  include CommandDesigner::LocalContext

  def evaluate_filters(method)
    super(method)
    evaluate_local_filters(method)
  end

end
