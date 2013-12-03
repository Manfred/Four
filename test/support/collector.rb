class Collector
  attr_accessor :_written

  def initialize
    self._written = []
  end

  def write(*args)
    self._written << args
  end

  def to_s
    _written.join("\n")
  end
end