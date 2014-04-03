class Kicker
  module Deprecated
    def execute(command)
      Kicker.debug("[DEPRECATED] Calling `execute' directly is deprecated, instead use `watcher.execute'. Called from #{_last_caller(caller)}.")
      watcher.execute(command)
    end

    private

    def _last_caller(stack)
      stack[0]
    end
  end
end