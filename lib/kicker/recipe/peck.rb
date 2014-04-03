require 'benchmark'

class Peck
  attr_reader :cwd, :watcher

  def initialize(cwd: Dir.pwd, watcher: nil)
    @cwd = cwd
    @watcher = watcher
  end

  def all_specs
    Dir.glob(File.join(@cwd, 'test/**/*_test.rb'))
  end

  def peck
    "bundle exec peck"
  end

  def format_time(seconds)
    if seconds < 1
      "#{(seconds * 1000).round} ms"
    else
      "#{(seconds * 100).round / 100.0} sec"
    end
  end

  def execute_specs(files)
    return if files.empty?
    realtime = (Benchmark.realtime {
      watcher.execute("#{peck} #{files.join(' ')}")
    })
    watcher.report "Running specs took #{format_time(realtime)}."
  end

  def map_to_specs(filename)
    Dir.glob(File.join(cwd, "test/**/#{File.basename(filename, '.rb')}_test.rb"))
  end

  def call(file_or_path, flags)
    ::Kicker.debug("Peck recipe: #{file_or_path}")
    specs = []
    case file_or_path
    when %r{_test\.rb$}
      specs << file_or_path
    when %r{\.rb$}
      specs.concat map_to_specs(file_or_path)
    when %r{\Aapp/views/([\w\\]+)/[^/]+\Z}
      specs.concat map_to_specs($1 + '_controller.rb')
    end
    execute_specs(specs)
  end
end

process(Peck.new(cwd: cwd, watcher: watcher))