class Kicker
  class Watcher
    class << self
      attr_accessor :formatter
    end

    self.formatter = Proc.new do |time, message|
      time.strftime('%H:%M:%S.') + time.usec.to_s[0,2] + ' | ' + message
    end

    def initialize(options={})
      @options = options
      @formatter = self.class.formatter
    end

    def report(message)
      $stdout.puts(@formatter.call(Time.now, message))
    end

    def run
      Tidings.watch(Dir.pwd) do |file_or_path, flags|
        report("Event: #{file_or_path}: #{flags.inspect}")
      end
    end
  end
end