require 'pty'

class Kicker
  class Watcher
    class << self
      attr_accessor :formatter
    end

    self.formatter = Proc.new do |time, message|
      time.strftime('%H:%M:%S.') + time.usec.to_s[0,2] + ' | ' + message
    end

    KICKFILES = %w(Kickfile .kick)

    def initialize(options={})
      @options = options
      @formatter = self.class.formatter
      @cwd = Dir.pwd
      @recipe = Recipe.new(watcher: self, cwd: @cwd)
      KICKFILES.each do |path|
        kickfile = File.join(@cwd, path)
        if File.exist?(kickfile)
          @recipe.load(kickfile)
        end
      end
    end

    def report(message)
      $stdout.puts(@formatter.call(Time.now, message))
    end

    def write(buffer)
      $stdout.write(buffer)
    end

    def execute(command)
      Kicker.debug("Executing: #{command}")
      PTY.open do |master, slave|
        read, write = IO.pipe
        pid = spawn(command, in: read, out: slave)
        read.close
        slave.close

        write(master.read)
      end
    end

    def run
      Kicker.debug("Started watching: #{@cwd}")
      Tidings.watch(@cwd) do |file_or_path, flags|
        Kicker.debug("Event: #{file_or_path}: #{flags.inspect}")
        @recipe.call(file_or_path, flags)
      end
    end
  end
end