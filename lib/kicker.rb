require 'tidings'
require 'kicker/core_ext/array'

class Kicker
  autoload :CLI,          'kicker/cli'
  autoload :Deprecated,   'kicker/deprecated'
  autoload :Formatter,    'kicker/formatter'
  autoload :OptionParser, 'kicker/option_parser'
  autoload :Script,       'kicker/script'
  autoload :VERSION,      'kicker/version'
  autoload :Watcher,      'kicker/watcher'

  extend Kicker::Formatter

  def self.debug(*)
    # By default we ignore all debugging information
  end

  def self.version
    Kicker::VERSION
  end
end