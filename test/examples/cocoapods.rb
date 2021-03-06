# This script uses deprecated syntax is purely for testing purposes.

recipe :ruby

Kicker::Recipes::Ruby.runner_bin = 'bacon'

process do |files|
  specs = files.take_and_map do |file|
    if file =~ %r{lib/cocoapods/(.+?)\.rb$}
      s = Dir.glob("spec/**/#{File.basename(file, '.rb')}_spec.rb")
      s.uniq unless s.empty?
    end
  end
  Kicker::Recipes::Ruby.run_tests(specs)
end

# Have written this so many times, probably should make a recipe out of it.
process do |files|
  files.each do |file|
    case file
    when 'Gemfile'
      files.delete(file)
      execute 'bundle install'
    end
  end
end

recipe :ignore
ignore(/.*\/?tags/)
ignore(/.*\/?\.git/)
