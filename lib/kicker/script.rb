class Kicker
  class Script
    class Context
      attr_accessor :cwd, :watcher, :script

      def initialize(cwd: Dir.pwd, watcher: nil, script: nil)
        @cwd = cwd
        @watcher = watcher
        @script = script
      end

      def recipe(name)
        filename = File.join(Kicker::Script.recipes_path, name.to_s + '.rb')
        if File.exist?(filename)
          ::Kicker.debug("Loading recipe: #{filename}")
          load(filename)
        else
          ::Kicker.debug("Unknown recipe: #{name}")
        end
      end

      def load(filename)
        eval(File.read(filename))
      end

      def process(callable=nil, &block)
        processor = callable || block
        ::Kicker.debug("Adding processor: #{processor}")
        script.processors << processor
      end
    end

    class << self
      attr_accessor :recipes_path
    end
    self.recipes_path = File.expand_path('recipe', __dir__)

    attr_accessor :cwd, :watcher, :recipes, :processors

    def initialize(cwd: Dir.pwd, watcher: nil)
      @cwd = cwd
      @watcher = watcher
      @recipes = []
      @processors = []
      @context = Kicker::Script::Context.new(cwd: @cwd, watcher: @watcher, script: self)
    end

    def recipe(name)
      @context.recipe(name)
    end

    def load(filename)
      @context.load(filename)
    end

    def call(file_or_path, flags)
      @processors.each do |processor|
        processor.call(file_or_path, flags)
      end
    end

    def self.available_recipes
      Dir.glob(File.join(recipes_path, '*.rb')).map do |filename|
        File.basename(filename, '.rb')
      end
    end
  end
end