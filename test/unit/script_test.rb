require File.expand_path('../test_helper', __dir__)

describe Kicker::Script do
  it "returns available recipes" do
    Kicker::Script.available_recipes.should.not.be.empty
    Kicker::Script.available_recipes.should.include('ignore')
  end
end

describe "A", Kicker::Script do
  it "initializes with a CWD and Watcher" do
    cwd = '/path/to/code'
    watcher = shape(Kicker::Watcher)
    script = Kicker::Script.new(cwd: cwd, watcher: watcher)

    script.cwd.should == cwd
    script.watcher.should == watcher
    script.processors.should.be.empty
  end

  describe "concerning files" do
    before do
      @script = Kicker::Script.new
    end

    it "loads a script file" do
      @script.load(File.join(Kicker::Script.recipes_path, 'peck.rb'))
      # The Peck recipe adds a file path processor
      @script.processors.length.should === 1
    end
  end

  describe "concerning events" do
    before do
      @script = Kicker::Script.new
    end

    it "forwards events to all its processors instances" do
      one = EventCollector.new
      two = EventCollector.new
      @script.processors = [one, two]

      event = '/path', [:created, :file]
      @script.call(*event)

      one.collected.should == [event]
      two.collected.should == [event]
    end

    it "forwards events to all its processor procs" do
      events = []
      count = 0

      @script.processors << -> (file_or_path, flags) {
        events << [file_or_path, flags]
      }
      @script.processors << Proc.new { count += 1 }

      event = '/path', [:created, :file]
      @script.call(*event)

      events.should == [event]
      count.should == 1
    end
  end
end