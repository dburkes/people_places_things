class State
  attr_accessor :raw
  attr_accessor :sym
  
  def initialize(sym)
    raise "Unsupported state" if !FORWARD.has_key?(sym)
    self.sym = sym
  end
  
  def self.parse(string)
    token = string.strip.downcase
    sym = nil
    
    if FORWARD.has_key?(token.to_sym)
      sym = token.to_sym
    elsif REVERSE.has_key?(token)
      sym = REVERSE[token]
    end
    
    raise "Unsupported Format" if !sym

    ret = State.new sym
    ret.raw = string
    ret
  end
  
  def self.format(sym, fmt)
    State.new(sym).to_s(fmt)
  end
  
  def to_s(fmt = :full)
    raise "Unsupported Format" if !OUTPUT_FORMATS.include?(fmt)
    fmt == :full ? FORWARD[self.sym].capitalize : self.sym.to_s.upcase
  end
  
  OUTPUT_FORMATS = [:abbr, :full]
  
  private

  FORWARD = {
    :al => "alabama",
  	:ak => "alaska",
  	:az => "arizona",
  	:ar => "arkansas",
  	:ca => "california",
  	:co => "colorado",
  	:ct => "connecticut",
  	:de => "delaware",
  	:dc => "district of columbia",
  	:fl => "florida",
  	:ga => "georgia",
  	:hi => "hawaii",
  	:id => "idaho",
  	:il => "illinois",
  	:in => "indiana",
  	:ia => "iowa",
  	:ks => "kansas",
  	:ky => "kentucky",
  	:la => "louisiana",
  	:me => "maine",
  	:md => "maryland",
  	:ma => "massachusetts",
  	:mi => "michigan",
  	:mn => "minnesota",
  	:ms => "mississippi",
  	:mo => "missouri",
  	:mt => "montana",
  	:ne => "nebraska",
  	:nv => "nevada",
  	:nh => "new hampshire",
  	:nj => "new jersey",
  	:nm => "new mexico",
  	:ny => "new york",
  	:nc => "north carolina",
  	:nd => "north dakota",
  	:oh => "ohio",
  	:ok => "oklahoma",
  	:or => "oregon",
  	:pa => "pennsylvania",
  	:ri => "Rhode island",
  	:sc => "south carolina",
  	:sd => "south dakota",
  	:tn => "tennessee",
  	:tx => "texas",
  	:ut => "utah",
  	:vt => "vermont",
  	:va => "virginia",
  	:wa => "washington",
  	:wv => "west virginia",
  	:wi => "wisconsin",
  	:wy => "wyoming",
	}
	
	REVERSE = FORWARD.inject({}) {|r, f| r[f[1]] = f[0]; r}
end