require 'yaml'

# Provides two-way mapping between U.S. state and county names and their associated ANSI codes (formerly known as FIPS codes).
#
# == Examples
#
# To get the ANSI code for a state and county, you call ANSICounties.code_for, like so:
#
#  code = ANSICounties.code_for('GA', 'FULTON')
#  # => 13121
#
# You can also pass a single Hash argument:
#
#  code = ANSICounties.code_for(:state => 'ga', :county => 'fulton')
#  # => 13121
#
# Conversely, to get the state and county for an ANSI code, you call ANSICounties.data_for:
#
#  hash = ANSICounties.data_for(13121)
#  # => { :state => 'GA', :county => 'FULTON' }
#
# == Data source
#
# The data that makes up <tt>lib/ansi-counties/data/data.yml</tt> was generated from <tt>lib/ansi-counties/data/raw.txt</tt>, which was downloaded from 
# the {US Census website}[http://www.census.gov/geo/www/ansi/download.html].
class ANSICounties
  
  # Get the ANSI code for the given state and county.  If _data_or_state_ is a Hash, then it must contain <em>state</em> and <em>county</em> keys, otherwise, 
  # it is assumbed to be a String containing the state name.
  def self.code_for(data_or_state, county=nil)
    if data_or_state.is_a?(Hash)
      state, county = data_or_state[:state], data_or_state[:county]
    else
      state = data_or_state
    end
    
    forward_hash[key_for(state, county)] rescue nil
  end
  
  # Get the state and county names for a given ANSI code.  Returns a Hash containing <em>state</em> and <em>county</em> keys
  def self.data_for(code)
    reverse_hash[code]
  end
  
  def self.normalize_county_name(name)  #:nodoc:
    name.upcase.gsub("ST ", "ST. ").gsub("SAINT ", "ST. ")
  end
  
  def self.key_for(state, county)  #:nodoc:
    "#{state.upcase}/#{normalize_county_name(county)}"
  end
  
  private
  
  def self.forward_hash
    @@forward_hash ||= File.open(File.join(File.dirname(__FILE__), 'data', 'data.yml')) {|yf| YAML::load(yf)}
  end
  
  def self.reverse_hash
    @@reverse_hash ||= forward_hash.inject({}) do |h, kv| 
      state_county = kv[0].split('/')
      h[kv[1]] = { :state => state_county[0], :county => state_county[1]}
      h
    end
  end
end