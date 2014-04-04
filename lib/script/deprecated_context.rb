class Kicker
  class Script
    class DeprecatedContext < Kicker::Script::Context
      def execute(command)
        Kicker.debug("[DEPRECATED] Calling `execute' directly is deprecated, instead use `watcher.execute'. Called from #{_last_caller(caller)}.")
        watcher.execute(command)
      end

      def call(file_or_path, flags)
        files = [file_or_path]
        files.extend(Kicker::CoreExt::Array)
        @processors.each do |processor|
          processor.call(files)
        end
      end

      private

      def _last_caller(stack)
        stack[0]
      end
    end
  end
end
