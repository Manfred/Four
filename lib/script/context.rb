class Kicker
  class Script
    class Context
      attr_accessor :cwd, :watcher, :script

      def initialize(cwd: Dir.pwd, watcher: nil, script: nil)
        @cwd = cwd
        @watcher = watcher
        @script = script
        @processors = []
      end

      def recipe(name)
        filename = File.join(::Kicker::Script.recipes_path, name.to_s + '.rb')
        if File.exist?(filename)
          ::Kicker.debug("Loading recipe: #{filename}")
          load(filename)
        else
          ::Kicker.debug("Unknown recipe: #{name}")
        end
      end

      def load(filename)
        eval(File.read(filename), binding, filename)
      end

      def process(callable=nil, &block)
        processor = callable || block
        ::Kicker.debug("Adding processor: #{processor}")
        @processors << processor
      end

      def call(file_or_path, flags)
        @processors.each do |processor|
          processor.call(file_or_path, flags)
        end
      end
    end
  end
end