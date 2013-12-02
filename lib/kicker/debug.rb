class Kicker
  def self.debug(message)
    $stderr.puts(::Kicker::Watcher.formatter.call(Time.now, message))
  end
end