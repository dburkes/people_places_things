# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "people_places_things/version"

Gem::Specification.new do |s|
  s.name        = "people_places_things"
  s.version     = PeoplePlacesThings::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Danny Burkes"]
  s.email       = ["dburkes@netable.com"]
  s.homepage    = "http://github.com/dburkes/people_places_things"
  s.summary     = %q{Parsers and formatters for person names, street addresses, city/state/zip, phone numbers, etc.}
  s.description = %q{Parsers and formatters for person names, street addresses, city/state/zip, phone numbers, etc.}

  s.files         = Dir['README.textile', 'LICENSE', 'lib/**/*']
  s.require_paths = ["lib"]
  s.add_development_dependency('rspec', '2.6.0')
  s.add_development_dependency('rake', '0.8.6')
  s.add_development_dependency('pry', '0.9.5')
end
