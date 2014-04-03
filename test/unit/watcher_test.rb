require File.expand_path('../test_helper', __dir__)

describe Kicker::Watcher do
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
end