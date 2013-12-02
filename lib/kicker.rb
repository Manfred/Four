require 'tidings'

class Kicker
  autoload :Watcher, 'kicker/watcher'
  autoload :Recipe,  'kicker/recipe'

  def self.debug(*)
    # By default we ignore all debugging information
  end

  def self.run(options={})
    require 'kicker/debug'
    watcher = ::Kicker::Watcher.new(options)
    watcher.run
  end
end