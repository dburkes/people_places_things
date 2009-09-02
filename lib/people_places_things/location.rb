module PeoplePlacesThings
  class Location
    attr_accessor :city, :state, :zip, :raw
  
    def initialize(str)
      self.raw = str
    
      tokens = str.split(/\s|,/).collect {|t| t.strip}
    
      # try to parse last token as zip
      #
      self.zip = ZipCode.new(tokens.last) rescue nil
      tokens = tokens.slice(0..-2) if self.zip
    
      # try to parse last token as state
      #
      self.state = State.new(tokens.last) rescue nil
      tokens = tokens.slice(0..-2) if self.state
    
      # remainder must be city
      #
      self.city = tokens.join(' ').strip
      self.city = nil if self.city.empty?
    end
  
    def to_s
      [[self.city, (self.state.to_s(:abbr) rescue nil)].compact.join(','), self.zip.to_s].compact.join(' ')
    end
  end
end