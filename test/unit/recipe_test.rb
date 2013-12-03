require File.expand_path('../test_helper', __dir__)

describe Kicker::Recipe do
  it "returns available recipes" do
    Kicker::Recipe.available.should.not.be.empty
    Kicker::Recipe.available.should.include('ignore')
  end
end

describe "A", Kicker::Recipe do
  it "initializes with a CWD and Watcher" do
    cwd = '/path/to/code'
    watcher = shape(Kicker::Watcher)
    recipe = Kicker::Recipe.new(cwd: cwd, watcher: watcher)

    recipe.cwd.should == cwd
    recipe.watcher.should == watcher
    recipe.processors.should.be.empty
  end

  describe "concerning recipes" do
    before do
      @recipe = Kicker::Recipe.new
    end

    it "loads a named recipe" do
      @recipe.recipe(:peck)
      # The Peck recipe adds a file path processor
      @recipe.processors.length.should === 1
    end
  end

  describe "concerning events" do
    before do
      @recipe = Kicker::Recipe.new
    end

    it "forwards events to all its processors instances" do
      one = EventCollector.new
      two = EventCollector.new
      @recipe.processors = [one, two]

      event = '/path', [:created, :file]
      @recipe.call(*event)

      one.collected.should == [event]
      two.collected.should == [event]
    end

    it "forwards events to all its processor procs" do
      events = []
      count = 0

      @recipe.process do |file_or_path, flags|
        events << [file_or_path, flags]
      end
      @recipe.process(Proc.new { count += 1 })

      event = '/path', [:created, :file]
      @recipe.call(*event)

      events.should == [event]
      count.should == 1
    end
  end
end