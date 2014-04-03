require File.expand_path('../test_helper', __dir__)

describe Kicker::Watcher do
  describe "settings" do
    it "does not clear terminal before executing when option is not set" do
      collector = Collector.new
      watcher = Kicker::Watcher.new(
        clear_before_execute: false,
        out: collector
      )
      watcher.execute('ls')
      collector.to_s.should.not.include(Kicker::Watcher::CLEAR)
    end

    it "clears terminal before executing when option is set" do
      collector = Collector.new
      watcher = Kicker::Watcher.new(
        clear_before_execute: true,
        out: collector
      )
      watcher.execute('ls')
      collector.to_s.should.include(Kicker::Watcher::CLEAR)
    end

    it "returns a formatter based on its verbosity" do
      Kicker::Watcher.new.formatter_for_verbosity.should == Kicker.formatters[:regular]
      Kicker::Watcher.new(verbosity: :silent).formatter_for_verbosity.should == Kicker.formatters[:silent]
      Kicker::Watcher.new(verbosity: :quiet).formatter_for_verbosity.should == Kicker.formatters[:quiet]
    end
  end

  describe "formatters" do
    it "has a working quiet formatter" do
      collector = Collector.new
      watcher = Kicker::Watcher.new(
        verbosity: :quiet,
        out: collector
      )
      watcher.execute('ls')
      collector.to_s.should.include('Executing')
    end

    it "has a working silent formatter" do
      collector = Collector.new
      watcher = Kicker::Watcher.new(
        verbosity: :silent,
        out: collector
      )
      watcher.execute('ls')
      collector.to_s.should.not.include('Executing')
      collector.to_s.should.not == ''
    end
  end
end