require 'pty'
require 'tidings'

class Kicker
  autoload :Watcher, 'kicker/watcher'

  def self.run(options={})
    watcher = Kicker::Watcher.new(options)
    watcher.run
  end
end