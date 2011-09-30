require 'pry'
module PeoplePlacesThings
  class StreetAddress
    attr_accessor :number, :pre_direction, :name, :suffix, :post_direction, :unit_type, :unit, :raw
  
    def initialize(str)
      self.raw = str
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

    def to_postal_s
      parts = []
      parts << self.number if self.number
      parts << StreetAddress.string_for(self.pre_direction, :short) if self.pre_direction
      parts << self.name if self.name
      parts << StreetAddress.string_for(self.suffix, :short) if self.suffix
      parts << StreetAddress.string_for(self.post_direction, :short) if self.post_direction
      parts << StreetAddress.string_for(self.unit_type, :short) if self.unit_type
      parts << StreetAddress.string_for(self.unit, :short) if self.unit
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
  
    # to_postal_s uses the short version of each of the following
    # long version is in position 0
    # short version is in position 1 
    
    DIRECTIONS = {
      :north     => %w(north n n.),
      :northeast => %w(northeast ne ne. n.e.),
      :east      => %w(east e e.),
      :southeast => %w(southeast se se. s.e.),
      :south     => %w(south s s.),
      :southwest => %w(southwest sw sw. s.w.),
      :west      => %w(west w w.),
      :northwest => %w(northwest nw nw. n.w.)

    }
  
    SUFFIXES = {
    	:alley      => %w(alley aly ally allee al al.),
    	:anex       => %w(anex anx annex annx anx.),
    	:arcade     => %w(arcade arc arc.),
    	:avenue     => %w(avenue ave aven avenu avnue ave. av av.),
    	:bayou      => %w(bayou byu bayoo byu.),
    	:beach      => %w(beach bch bch.),
    	:bend       => %w(bend bnd bnd.),
    	:bluff      => %w(bluff blf bluf blf.),
    	:bluffs     => %w(bluffs blfs blfs.),
    	:bottom     => %w(bottom btm bot bottm btm.),
    	:boulevard  => %w(boulevard blvd blvd. boul boulv blv blv.),
    	:branch     => %w(branch br brnch br.),
    	:bridge     => %w(bridge brg brdge),
    	:brook      => %w(brook brk brk.),
    	:brooks     => %w(brooks brks),
    	:burg       => %w(burg bg),
    	:burgs      => %w(burgs bgs),
    	:bypass     => %w(bypass byp bypa bypas byps),
    	:camp       => %w(camp cp cmp),
    	:canyon     => %w(canyon cyn canyn cnyn cyn.),
    	:cape       => %w(cape cpe),
    	:causeway   => %w(causeway cswy causwa cswy.),
    	:center     => %w(center ctr cent centr cnter centre cntr ctr.),
    	:centers    => %w(centers ctrs),
    	:circle     => %w(circle cir circ circl crcl crcle cir.),
    	:cliff      => %w(cliff clf clf.),
    	:cliffs     => %w(cliffs clfs),
    	:club       => %w(club clb),
    	:common     => %w(common cmn),
    	:commons    => %w(commons cmns),
    	:corner     => %w(corner cor),
    	:corners    => %w(corners cors),
    	:condo      => %w(condo con con.),
    	:court      => %w(court ct ct. cor cor.),
    	:courts     => %w(courts cts cts.),
    	:cove       => %w(cove cv),
    	:coves      => %w(coves cvs),
    	:creek      => %w(creek crk crk.),
    	:crescent   => %w(crescent cres crsent crsnt),
    	:crest      => %w(crest crst),
    	:crossing   => %w(crossing xing xing. crssng crs crs.),
    	:crossroad  => %w(crossroad xrd),
    	:crossroads => %w(crossroads xrds),
    	:curve      => %w(curve curv),
    	:dale       => %w(dale dl),
    	:dam        => %w(dam dm),
    	:divide     => %w(divide dv div dvd),
    	:drive      => %w(drive dr driv drv dr.),
    	:drives     => %w(drives drs),
    	:estate     => %w(estate est),
    	:estates    => %w(estates ests),
    	:expressway => %w(expressway expy exp expr express expw expr),
    	:extension  => %w(extension ext ext.),
    	:extensions => %w(extensions exts),
    	:fall       => %w(fall fall),
    	:falls      => %w(falls fls),
    	:ferry      => %w(ferry fry frry),
    	:field      => %w(field fld),
    	:fields     => %w(fields flds),
    	:flat       => %w(flat flt),
    	:flats      => %w(flats flts),
    	:ford       => %w(ford, frd),
    	:fords      => %w(fords frds),
    	:forest     => %w(forest frst forests),
    	:forge      => %w(forge frg forg),
    	:forges     => %w(forges frgs),
    	:fork       => %w(fork frk),
    	:forks      => %w(forks frks),
    	:fort       => %w(fort ft frt),
    	:freeway    => %w(freeway fwy  freewy frway fwy.),
    	:garden     => %w(garden gdn gardn grden grdn),
    	:gardens    => %w(gardens gdns gdns.),
    	:gateway    => %w(gateway gtwy gatewy gatway gtway),
    	:glen       => %w(glen gln gl gl.),
    	:glens      => %w(glens glns),
    	:green      => %w(green grn grn.),
    	:greens     => %w(greens grns),
    	:grove      => %w(grove grv grov),
    	:groves     => %w(groves grvs),
    	:harbor     => %w(harbor hbr harb harbr hrbor),
    	:harbors    => %w(harbors hbrs),
    	:haven      => %w(haven hvn),
    	:heights    => %w(heights hts hts.),
    	:highway    => %w(highway hwy highwy hiway hiwy hway hwy. hgwy hgwy.),
    	:hill       => %w(hill hl),
    	:hills      => %w(hills hls),
    	:hollow     => %w(hollow holw hllw hollows holw holws),
    	:inlet      => %w(inlet inlt),
    	:island     => %w(island is islnd),
    	:islands    => %w(islands iss islnds),
    	:isle       => %w(isle isle isles),
    	:junction   => %w(junction jct jction jctn junctn juncton),
    	:junctions  => %w(junctions jcts jctns),
    	:key        => %w(key ky),
    	:keys       => %w(keys kys),
    	:knoll      => %w(knoll knl knl.),
    	:knolls     => %w(knolls knls),
    	:lake       => %w(lake lk),
    	:lakes      => %w(lakes lks),
    	:land       => %w(land land),
    	:landing    => %w(landing lndg lndg.),
    	:lane       => %w(lane ln ln.),
    	:light      => %w(light lgt),
    	:lights     => %w(lights lgts),
    	:loaf       => %w(loaf lf),
    	:lock       => %w(lock lck),
    	:locks      => %w(locks lcks),
    	:lodge      => %w(lodge ldg ldge lodg),
    	:loop       => %w(loop loop loops),
    	:mall       => %w(mall mall),
    	:manor      => %w(manor mnr),
    	:manors     => %w(manors mnrs),
    	:meadow     => %w(meadow mdw),
    	:meadows    => %w(meadows mdws medows mdws.),
    	:mews       => %w(mews mews),
    	:mill       => %w(mill ml),
    	:mills      => %w(mills mls),
    	:mission    => %w(mission msn missn),
    	:motorway   => %w(motorway mtwy),
    	:mount      => %w(mount mt mnt),
    	:mountain   => %w(mountain mtn mntn mountin mtn. mnt mnt.),
    	:mountains  => %w(mountains mtns),
    	:neck       => %w(neck nck),
    	:orchard    => %w(orchard orch orchrd),
    	:oaks       => %w(oaks),
    	:oval       => %w(oval oval ovl),
    	:overpass   => %w(overpass opas),
    	:park       => %w(park park pk. prk prk.),
    	:parkway    => %w(parkway pkwy pkwy. pky pky.),
    	:parkways   => %w(parkways pkwy pkwys),
    	:pass       => %w(pass pass),
    	:passage    => %w(passage psge),
    	:path       => %w(path path paths),
    	:pike       => %w(pike pike pikes),
    	:pine       => %w(pine pne),
    	:pines      => %w(pines pnes),
    	:pier       => %w(pier),
    	:place      => %w(place pl pl.),
    	:plain      => %w(plain pln),
    	:plains     => %w(plains plns),
    	:plaza      => %w(plaza plz plza plz.),
    	:point      => %w(point pt pt. pnt pnt.),
    	:points     => %w(points pts),
    	:port       => %w(port prt),
    	:ports      => %w(ports prts),
    	:prairie    => %w(prairie pr prarie),
    	:radial     => %w(radial radl rad radiel),
    	:ramp       => %w(ramp ramp),
    	:ranch      => %w(ranch rnch ranches rnchs),
    	:rapid      => %w(rapid rpd),
    	:rapids     => %w(rapids rpds),
    	:rest       => %w(rest rst),
    	:ridge      => %w(ridge rdg rdge ri.),
    	:ridges     => %w(ridges rdgs),
    	:river      => %w(river riv rvr),
    	:road       => %w(road rd rd.),
    	:roads      => %w(roads rds),
    	:route      => %w(route rte),
    	:row        => %w(row row),
    	:rue        => %w(rue rue),
    	:run        => %w(run run),
    	:shoal      => %w(shoal shl),
    	:shoals     => %w(shoals shls),
    	:shore      => %w(shore shr shoar),
    	:skyway     => %w(skyway skwy),
    	:spring     => %w(spring spg spng sprng),
    	:springs    => %w(springs spgs spgs.),
    	:spur       => %w(spur spur spurs),
    	:square     => %w(square sq sqr sqre squ sq.),
    	:squares    => %w(squares sqs sqrs),
    	:station    => %w(station sta sta.),
    	:stravenue  => %w(stravenue stra strav straven  stravn strvnue),
    	:stream     => %w(stream strm steme),
    	:street     => %w(street st strt str st.),
    	:streets    => %w(streets sts),
    	:summit     => %w(summit smt sumit sumitt),
    	:terrace    => %w(terrace ter ter. te te.),
    	:throughway => %w(throughway trwy),
    	:trace      => %w(trace trce traces),
    	:track      => %w(track trak tracks trk trks),
    	:trafficway => %w(trafficway trfy),  	
    	:trail      => %w(trail trl trails trls trl. tl tl.),
    	:trailer    => %w(trailer trlr trlrs),
    	:tunnel     => %w(tunnel tunl tunls tunnels tunnl),
    	:turnpike   => %w(turnpike tpke turnpk trnpk tpke.),
    	:underpass  => %w(underpass upas),
    	:union      => %w(union un),
    	:valley     => %w(valley vly vlly vally vly.),
    	:valleys    => %w(valleys vlys),
    	:viaduct    => %w(viaduct via vdct viadct),
    	:view       => %w(view vw),
    	:views      => %w(views vws),
    	:village    => %w(village vlg vill villg villiage vlg),
    	:villages   => %w(villages vlgs),
    	:ville      => %w(ville vl),
    	:vista      => %w(vista vs vis vist vst vsta),
    	:walk       => %w(walk walk walks),
    	:wall       => %w(wall wall),
    	:way        => %w(way way wy),
    	:ways       => %w(ways ways),
    	:well       => %w(well wl),
    	:wells      => %w(wells wls)

    }
  
    UNIT_TYPES = {
      :suite      => %w(suite ste ste.),
      :number     => %w(number # nbr nbr.),
      :apartment  => %w(apartment apt apt.),
      :building   => %w(building bldg),
      :department => %w(department dept),
      :floor      => %w(floor fl),
      :room       => %w(room rm),
      :space      => %w(space spc),
      :stop       => %w(stop stop),
      :unit       => %w(unit unit)

    }
  
    # to_postal_s format uses the short form
    SUPPORTED_FORMS = [:long, :short]
  end
end