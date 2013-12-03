class EventCollector
  attr_accessor :collected

  def initialize
    @collected = []
  end

  def call(file_or_path, flags)
    @collected << [file_or_path, flags]
  end
end