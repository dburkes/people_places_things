module PeoplePlacesThings
  class StreetAddress
    attr_accessor :number, :pre_direction, :name, :suffix, :post_direction, :unit_type, :unit, :raw
  
    def initialize(str)
      tokens = str.split(/[\s,]/).select {|s| !s.empty?}
    
      # Check the first token for leading numericality.  If so, set number to the first token, and delete it
      #
      if tokens.first =~ /(^\d+.*)/
        self.number = $1
        tokens.shift
      end
    
      # If at least two tokens remain, check next-to-last token as unit type.  If so, set unit_type and unit, and delete the tokens
      #
      if tokens.size > 1 
        self.unit_type = StreetAddress.find_token(tokens[-2], UNIT_TYPES)
        if self.unit_type
          self.unit = tokens[-1]
          tokens.slice!(tokens.size - 2, 2)
        end
      end
    
      # If at least one token remains, check last token for directionality.  If so, set post_direction and delete the token
      #
      if tokens.size > 0
        self.post_direction = StreetAddress.find_token(tokens[-1], DIRECTIONS)
        if self.post_direction
          post_direction_token = tokens[-1]
          tokens.slice!(tokens.size - 1)
        end
      end
    
      # If at least one token remains, check last token for suffix.  If so, self set.suffix and delete the token
      #
      if tokens.size > 0
        self.suffix = StreetAddress.find_token(tokens[-1], SUFFIXES)
        tokens.slice!(tokens.size - 1) if self.suffix
      end
    
      # If at least two tokens remain, check first for directionality. If so, set pre_direction and delete token
      #
      if tokens.size > 1
        self.pre_direction = StreetAddress.find_token(tokens.first, DIRECTIONS)
        tokens.shift if self.pre_direction
      end
    
      # if any tokens remain, set joined remaining tokens as name, otherwise, set name to post_direction, if set, and set post_direction to nil
      #
      if tokens.size > 0
        self.name = tokens.join(' ')
      else
        self.name = post_direction_token
        self.post_direction = nil
      end
    
      validate_parts
    end
  
    def to_s
      parts = []
      parts << self.number if self.number
      parts << DIRECTIONS[self.pre_direction].first if self.pre_direction
      parts << self.name if self.name
      parts << SUFFIXES[self.suffix].first if self.suffix
      parts << DIRECTIONS[self.post_direction].first if self.post_direction
      parts << UNIT_TYPES[self.unit_type].first if self.unit_type
      parts << self.unit if self.unit
      parts.join(' ')
    end
  
    def self.string_for(symbol, form)
      raise "Requested unknown form \"#{type}\" for :#{symbol}" if !SUPPORTED_FORMS.include?(form)
    
      val = DIRECTIONS[symbol] || SUFFIXES[symbol] || UNIT_TYPES[symbol]

      if val
        val = ((val[SUPPORTED_FORMS.index(form)] rescue nil) || (val.first rescue val))
      end
    
      val
    end
  
    private
  
    def validate_parts
      [:pre_direction, :suffix, :post_direction, :unit_type].each do |p|
        if self.send(p)
          legal_values = p == :suffix ? SUFFIXES : p == :unit_type ? UNIT_TYPES : DIRECTIONS
          raise "Invalid #{p.to_s} \"#{self.send(p)}\"" if !legal_values.include?(self.send(p))
        end
      end
    end
  
    def self.find_token(token, values)
      values.keys.each do |k|
        return k if values[k].detect {|v| v.casecmp(token) == 0}
      end
    
      nil
    end
  
    DIRECTIONS = {
      :north => %w(north n n.),
      :northeast => %w(northeast ne ne. n.e.),
      :east => %w(east e e.),
      :southeast => %w(southeast se se. s.e.),
      :south => %w(south s s.),
      :southwest => %w(southwest sw sw. s.w.),
      :west => %w(west w w.),
      :northwest => %w(northwest nw nw. n.w.)
    }
  
    SUFFIXES = {
    	:alley => %w(alley al al.),
    	:avenue => %w(avenue ave ave. av av.),
    	:beach => %w(beach bch bch.),
    	:bend => %w(bend),
    	:boulevard => %w(boulevard blvd blvd. blv blv.),
    	:center => %w(center ctr ctr.),
    	:circle => %w(circle cir cir.),
    	:cliff => %w(cliff clf clf.),
    	:club => %w(club),
    	:condo => %w(condo con con.),
    	:court => %w(court ct ct. cor cor.),
    	:cove => %w(cove),
    	:creek => %w(creek crk crk.),
    	:crossing => %w(crossing xing xing. crs crs.),
    	:drive => %w(drive dr dr.),
    	:extension => %w(extension ext ext.),
    	:freeway => %w(freeway fwy fwy.),
    	:gardens => %w(gardens gdns gdns.),
    	:glen => %w(glen gl gl.),
    	:green => %w(green grn grn.),
    	:heights => %w(heights hts hts.),
    	:highway => %w(highway hwy hwy. hgwy hgwy.),
    	:hill => %w(hill),
    	:knoll => %w(knoll knl knl.),
    	:lake => %w(lake),
    	:lane => %w(lane ln ln.),
    	:landing => %w(landing lndg lndg.),
    	:loop => %w(loop),
    	:meadows => %w(meadows mdws mdws.),
    	:manor => %w(manor mnr mnr.),
    	:mountain => %w(mountain mtn mtn. mnt mnt.),
    	:oaks => %w(oaks),
    	:oval => %w(oval),
    	:park => %w(park pk pk. prk prk.),
    	:parkway => %w(parkway pkwy pkwy. pky pky.),
    	:pier => %w(pier),
    	:place => %w(place pl pl.),
    	:plaza => %w(plaza plz plz.),
    	:point => %w(point pt pt. pnt pnt.),
    	:ridge => %w(ridge ri ri.),
    	:road => %w(road rd rd.),
    	:row => %w(row),
    	:run => %w(run),
    	:springs => %w(springs spgs spgs.),
    	:square => %w(square sq sq.),
    	:street => %w(street st st.),
    	:station => %w(station sta sta.),
    	:terrace => %w(terrace ter ter. te te.),
    	:turnpike => %w(turnpike tpke tpke.),
    	:trace => %w(trace trc trc.),
    	:trail => %w(trail trl trl. tl tl.),
    	:valley => %w(valley vly vly.),
    	:walk => %w(walk),
    	:way => %w(way)
    }
  
    UNIT_TYPES = {
      :suite => %w(suite ste ste.),
      :number => %w(number # nbr nbr.),
      :apartment => %w(apartment apt apt.)
    }
  
    SUPPORTED_FORMS = [:long, :short]
  end
end