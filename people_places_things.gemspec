# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{people_places_things}
  s.version = "1.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Danny Burkes"]
  s.date = %q{2009-08-28}
  s.description = %q{Parsers and formatters for person names, street addresses, city/state/zip, phone numbers, etc.}
  s.email = %q{dburkes@netable.com}
  s.extra_rdoc_files = [
    "README.rdoc"
  ]
  
  s.files = Dir['lib/**/*']
  s.files << Dir['bin/*']
  s.files << Dir['[A-Z]*']
  s.files << Dir['spec/**/*']
  
  s.has_rdoc = true
  s.homepage = %q{http://github.com/dburkes/people_places_things}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Parsers and formatters for person names, street addresses, city/state/zip, phone numbers, etc.}
  s.test_files = [
    "spec/person_name_spec.rb",
    "spec/street_address_spec.rb",
    "spec/ansi_counties_spec.rb",
    "spec/helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
