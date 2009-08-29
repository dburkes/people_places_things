require File.join(File.dirname(__FILE__), 'people_places_things', 'street_address', 'street_address')
require File.join(File.dirname(__FILE__), 'people_places_things', 'person_name', 'person_name')
require File.join(File.dirname(__FILE__), 'people_places_things', 'ansi_counties', 'ansi_counties')
require File.join(File.dirname(__FILE__), 'people_places_things', 'phone_number', 'phone_number')
require File.join(File.dirname(__FILE__), 'people_places_things', 'zip_code', 'zip_code')

module PeoplePlacesThings
  VERSION = File.read('VERSION').chomp.strip rescue "Unknown"
end