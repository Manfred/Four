$:.unshift File.expand_path('../lib', __FILE__)

require 'kicker/version'
require 'date'

Gem::Specification.new do |s|
  s.name     = "kicker"
  s.version  = Kicker::VERSION
  s.date     = Time.new

  s.summary  = "A lean, agnostic, flexible file-change watcher."
  s.description = "Kicker lets you watch filesystem changes and act in them with predefined or custom recipes."
  s.authors  = ["Eloy Duran", "Manfred Stienstra"]
  s.homepage = "http://github.com/Manfred/kicker"
  s.email    = %w{ eloy.de.enige@gmail.com manfred@fngtps.com }

  s.executables      = %w{ kicker }
  s.require_paths    = %w{ lib }
  s.files            = Dir[
    'bin/kicker',
    'lib/**/*.rb',
    'README.rdoc',
    'COPYING',
  ]
  s.extra_rdoc_files = %w{ COPYING README.rdoc }

  s.add_development_dependency("peck")
  s.add_development_dependency("fakefs")
end

