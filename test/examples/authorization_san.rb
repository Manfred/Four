# This script uses deprecated syntax is purely for testing purposes.

recipe :ruby

process do |files|
  Ruby.run_tests(files.take_and_map do |file|
    case file
    when /^test\/cases/
      file
    when /^lib/
      Dir.glob("test/cases/**/*_test.rb")
    end
  end)
end