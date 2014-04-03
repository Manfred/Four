class Kicker
  def self.debug(message)
    $stderr.puts(::Kicker.formatter.call(Time.now, message))
  end
end