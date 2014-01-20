require 'tidings'

class Kicker
  autoload :CLI,          'kicker/cli'
  autoload :Watcher,      'kicker/watcher'
  autoload :OptionParser, 'kicker/option_parser'
  autoload :Recipe,       'kicker/recipe'
  autoload :VERSION,      'kicker/version'

  def self.debug(*)
    # By default we ignore all debugging information
  end

  def self.version
    Kicker::VERSION
  end
end