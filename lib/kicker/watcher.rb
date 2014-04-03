require 'pty'

class Kicker
  class Watcher
    class << self
      attr_accessor :buffer_size
    end

    self.buffer_size = 1

    KICKFILES = %w(Kickfile .kick)
    CLEAR = "\e[H\e[2J"

    def initialize(options={})
      @options = options
      Kicker.debug("Watcher options: #{@options}")

      @buffer_size = self.class.buffer_size
      
      @out = options[:out] || $stdout

      @cwd = Dir.pwd
      @script = Script.new(watcher: self, cwd: @cwd)

      load
    end

    def load_kickfile
      if @options[:kickfile]
        Kicker.debug("Loading Kickfile from: #{@options[:kickfile]}")
        @script.load(@options[:kickfile])
        true
      else
        false
      end
    end

    def load_default_kickfile
      loaded = false
      KICKFILES.each do |path|
        kickfile = File.join(@cwd, path)
        if File.exist?(kickfile)
          Kicker.debug("Loading Kickfile from: #{kickfile}")
          @script.load(kickfile)
          loaded = true
        end
      end
      loaded
    end

    def load_recipes
      @options[:recipes].each do |recipe|
        @script.recipe(recipe)
      end if @options[:recipes]
    end

    def load
      load_kickfile || load_default_kickfile
      load_recipes
    end

    def clear_before_execute?
      @options[:clear_before_execute] == true
    end

    def verbosity
      @options[:verbosity] || :regular
    end

    def formatter_for_verbosity
      Kicker.formatter(verbosity)
    end

    def report(message)
      unless verbosity == :silent
        @out.puts(formatter_for_verbosity.call(Time.now, message))
      end
    end

    def write(buffer)
      @out.write(buffer)
    end

    def clear
      write(CLEAR)
    end

    def execute(command)
      clear if clear_before_execute?
      report("Executing: #{command}")
      write("\n") unless verbosity == :silent
      PTY.open do |master, slave|
        read, write = IO.pipe
        pid = spawn(command, in: read, out: slave)
        read.close
        slave.close
        while(buffer = master.read(@buffer_size))
          write(buffer)
        end
      end
      write("\n")
    end

    def run
      report("Started watching: #{@cwd}")
      Tidings.watch(@cwd) do |file_or_path, flags|
        file_or_path = file_or_path[@cwd.length+1..-1]
        Kicker.debug("Event: #{file_or_path}: #{flags.inspect}")
        @script.call(file_or_path, flags)
      end
    end
  end
end