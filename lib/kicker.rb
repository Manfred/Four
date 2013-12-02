require 'pty'
require 'tidings'

class Kicker
  class << self
    attr_accessor :formatter
  end

  self.formatter = Proc.new do |time, message|
    time.strftime('%H:%M:%S.') + time.usec.to_s[0,2] + ' | ' + message
  end

  def self.report(message)
    $stdout.puts(formatter.call(Time.now, message))
  end

  def self.run
    Tidings.watch(Dir.pwd) do |file_or_path, flags|
      Kicker.report("Event: #{file_or_path}: #{flags.inspect}")
    end
  end
end