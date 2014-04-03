class Collector
  attr_accessor :_written

  def initialize
    self._written = []
  end

  def puts(*args)
    args.each { |line| write(line.end_with?("\n") ? line : line + "\n") }
  end

  def write(*args)
    self._written << args
  end

  def to_s
    _written.join
  end
end