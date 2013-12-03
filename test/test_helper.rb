require 'peck/flavors/vanilla'

$root = File.expand_path('..', __dir__)

$:.unshift(File.join($root, 'lib'))

require 'kicker'

Dir.glob(File.join($root, 'test/support/*.rb')).each do |filename|
  require filename
end

Peck::Context.once do |context|
  include Test::IOHelpers
  include Bendy::Shape
end