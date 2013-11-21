require 'rdoc/task'

task :default => :test

desc "Run all tests"
task :test do
  Dir[File.dirname(__FILE__) + '/test/**/*_test.rb'].each do |file|
    load file
  end
end
