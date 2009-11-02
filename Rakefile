begin; require 'rubygems'; rescue LoadError; end

require 'rake'
require 'rake/rdoctask'
require 'spec/rake/spectask'

desc "Run all specs"
Spec::Rake::SpecTask.new('specs') do |t|
  t.libs << 'lib'
  t.spec_files = FileList['spec/**/*.rb']
end

Dir['tasks/*.rake'].each{|f| import(f) }

task :default => [:specs]

begin
  require 'jeweler'
  require 'lib/people_places_things'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "people_places_things"
    gemspec.version = PeoplePlacesThings::VERSION
    gemspec.summary = "Parsers and formatters for person names, street addresses, city/state/zip, phone numbers, etc."
    gemspec.email = "dburkes@netable.com"
    gemspec.homepage = "http://github.com/dburkes/people_places_things"
    gemspec.description = "Parsers and formatters for person names, street addresses, city/state/zip, phone numbers, etc."
    gemspec.authors = ["Danny Burkes"]
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

namespace :doc do
  desc "Generate RDoc"
  Rake::RDocTask.new('people_places_things') { |rdoc|
    rdoc.rdoc_dir = 'doc'
    rdoc.options << '--inline-source'
    # rdoc.rdoc_files.include('README.md')
    # rdoc.rdoc_files.include('lib/**/*')
    # rdoc.rdoc_files.exclude('lib/ansi_counties/data/**/*')
  }
end
