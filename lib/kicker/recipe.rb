class Kicker
  class Recipe
    class << self
      attr_accessor :recipes_path
    end
    self.recipes_path = File.expand_path('recipe', __dir__)

    attr_accessor :cwd, :watcher

    def initialize(cwd: Dir.pwd, watcher: nil)
      @cwd = cwd
      @watcher = watcher
      @processors = []
    end

    def load(filename)
      ::Kicker.debug("Loading file: #{filename}")
      eval(File.read(filename), binding, filename)
    end

    def recipe(name)
      filename = File.join(self.class.recipes_path, name.to_s + '.rb')
      if File.exist?(filename)
        ::Kicker.debug("Loading recipe: #{filename}")
        load(filename)
      else
        ::Kicker.debug("Unknown recipe: #{name}")
      end
    end

    def process(callable)
      ::Kicker.debug("Adding processor: #{callable}")
      @processors << callable
    end

    def call(file_or_path, flags)
      @processors.each do |processor|
        processor.call(file_or_path, flags)
      end
    end
  end
end