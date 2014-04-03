class Kicker
  class CLI
    def initialize(argv)
      @options, @argv = Kicker::OptionParser.parse(argv)
    end

    def switches
      @options.map(&:first)
    end

    def any_switch?(*test)
      !(switches & test).empty?
    end

    def option_value(*switches)
      @options.each do |key, value|
        if switches.include?(key)
          return value
        end
      end; nil
    end

    def osx?
      RUBY_PLATFORM.downcase.include?("darwin")
    end

    def debug?
      $DEBUG || any_switch?('d', 'debug')
    end

    def show_version?
      any_switch?('v', 'version')
    end

    def show_usage?
      any_switch?('h', 'help')
    end

    def show_version
      puts Kicker::VERSION
    end

    def available_recipes_as_sentence
      available = Kicker::Script.available_recipes
      available[0..-2].join(', ') + ', and ' + available[-1]
    end

    def show_usage
      puts "Usage: #{$0} [options] [paths to watch]"
      puts ""
      puts "  Available recipes: #{available_recipes_as_sentence}."
      puts ""
      puts "OPTIONS"
      puts ""
      if osx?
      puts " -a, --activate:  The application to activate when a notification is clicked. Defaults to `com.apple.Terminal'."
      end
      puts " -c, --clear:     Clear console before each run."
      puts " -d, --debug:     Print debug messages for Kicker internals."
      puts " -l, --latency:   The time to collect events before acting on them. (float)."
      puts " -n, --no-notify: Don't send notifications."
      puts " -q, --quiet:     Quiet output. Don't print timestamps when logging."
      puts " -r, --recipe:    Load named recipe."
      puts " -s, --silent:    Don't output anything."
      puts " -v, --version:   Print the Kicker version."
    end

    def verbosity
      if any_switch?('s', 'silent')
        :silent
      elsif any_switch?('q', 'quiet')
        :quiet
      else
        :regular
      end
    end

    def recipes
      []
    end

    def options
      {
        activate: option_value('a', 'activate'),
        verbosity: verbosity,
        clear_before_execute: any_switch?('c', 'clear'),
        notifications: !any_switch?('n', 'no-notify'),
        recipes: recipes,
      }
    end

    def run
      if show_version?
        show_version
      elsif show_usage?
        show_usage
      else
        require 'kicker/debug' if debug?
        watcher = ::Kicker::Watcher.new(options)
        watcher.run
      end
    end

    def self.run(argv)
      new(argv).run
    end
  end
end