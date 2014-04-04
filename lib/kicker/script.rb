class Kicker
  class Script
    autoload :Context,           'script/context'
    autoload :DeprecatedContext, 'script/deprecated_context'

    class << self
      attr_accessor :recipes_path
    end
    self.recipes_path = File.expand_path('recipe', __dir__)

    attr_accessor :cwd, :watcher, :recipes, :contexts

    def initialize(cwd: Dir.pwd, watcher: nil)
      @cwd = cwd
      @watcher = watcher
      @recipes = []
      @contexts = []
    end

    def create_context
      context = Kicker::Script::Context.new(cwd: cwd, watcher: watcher, script: self)
      @contexts << context
      context
    end

    def recipe(name)
      create_context.recipe(name)
    end

    def load(filename)
      create_context.load(filename)
    end

    def call(file_or_path, flags)
      contexts.each do |context|
        context.call(file_or_path, flags)
      end
    end

    def self.available_recipes
      Dir.glob(File.join(recipes_path, '*.rb')).map do |filename|
        File.basename(filename, '.rb')
      end
    end
  end
end