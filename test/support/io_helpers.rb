module Test
  module IOHelpers
    def capture_stdout
      before = $stdout
      collector = Collector.new
      begin
        $stdout = collector
        yield
      ensure
        $stdout = before
      end
      collector.to_s
    end
  end
end