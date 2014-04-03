class Kicker
  module Formatter
    def formatters
      @formatters ||= {
        silent:  Proc.new {},
        quiet:   Proc.new { |time, message| message },
        regular: Proc.new { |time, message| time.strftime('%H:%M:%S.') + time.usec.to_s[0,2] + ' | ' + message }
      }
    end

    def formatter(name=:regular)
      formatters[name]
    end
  end
end