class PersonName
  attr_accessor :parts
  attr_accessor :raw

  def initialize(options={})
    @parts = options.inject({}) do |parts, (k, v)| 
      sym_key = (k.to_sym rescue key) || key
      parts[sym_key] = v if SUPPORTED_PARTS.include?(sym_key)
      parts
    end
  end

  def self.parse(string, fmt = :auto_detect)
    raise "Unsupported Format" if !PARSE_FORMATS.include?(fmt)
    
    if fmt == :auto_detect
      fmt = string.include?(',') ? :last_first_middle : :first_middle_last
    end
    
    args = {}

    parts = string.split(/\s|,/).collect {|p| p.strip}.reject {|p| PersonName.blank?(p) || p == ',' }
  
    if parts.size == 1
      args[:last] = parts.first
    else
      case fmt
        when :first_middle_last
          if parts.size > 2 and SUPPORTED_SUFFIXES.detect {|s| s.casecmp(parts.last) == 0}
            args[:suffix] = normalize_suffix(parts.last)
            parts.delete_at(parts.size - 1)
          end
        
          args[:first] = parts.first if parts.size > 0
          args[:last] = parts.last if parts.size > 1
        
          if parts.size > 2 && ODD_LAST_NAME_PREFIXES.detect {|s| s.casecmp(parts[-2]) == 0}
            args[:last] = "#{parts[-2]}#{args[:last]}"
            parts.delete_at(parts.size - 2)
          end
            
          args[:middle] = parts[1..(parts.size - 2)].join(' ') if parts.size > 2
    
        when :last_first_middle
          args[:last] = parts.first if parts.size > 0
        
          if parts.size > 1 && ODD_LAST_NAME_PREFIXES.detect {|s| s.casecmp(args[:last]) == 0}
            args[:last] << parts[1]
            parts.delete_at(1)
          end

          if parts.size > 2 and SUPPORTED_SUFFIXES.detect {|s| s.casecmp(parts[1]) == 0}
            args[:suffix] = normalize_suffix(parts[1])
            parts.delete_at(1)
          end

          args[:first] = parts[1] if parts.size > 1
          args[:middle] = parts[2..(parts.size - 1)].join(' ') if parts.size > 2
      end
    end
  
    n = PersonName.new args
    n.raw = string
    n
  end
  
  def self.format(options, fmt=:full)
    PersonName.new(options).to_s(fmt)
  end

  def [](which)
    @parts[which]
  end

  def to_s(fmt = :full)
    raise "Unsupported Format" if !OUTPUT_FORMATS.include?(fmt)

    case fmt
      when :first, :middle, :last
        @parts[fmt]
      
      when :full
        [@parts[:first], @parts[:middle], @parts[:last], @parts[:suffix]].compact.join(' ')
        
      when :full_reverse
        [@parts[:last], @parts[:first], @parts[:middle], @parts[:suffix]].compact.join(' ')
      
      when :first_space_last
        [@parts[:first], @parts[:last]].compact.join(' ')
      
      when :last_space_first
        [@parts[:last], @parts[:first]].compact.join(' ')
      
      when :last_comma_first
        [@parts[:last], @parts[:first]].compact.join(',')
      
      when :last_comma_space_first
        [(@parts[:first] ? "#{@parts[:last]}," : @parts[:last]), @parts[:first]].compact.join(' ')
    end
  end

  def first
    @parts[:first]
  end

  def first_i
    first[0,1] rescue nil
  end

  def middle
    @parts[:middle]
  end

  def middle_i
    middle[0,1] rescue nil
  end

  def last
    @parts[:last]
  end

  def last_i
    last[0,1] rescue nil
  end
  
  def suffix
    @parts[:suffix]
  end
  
  def eql?(other, initials_only=false)
    if other.is_a?(PersonName)
      (self.parts.keys & other.parts.keys).all? do |k|
        msg = (k != :last && initials_only) ? "#{k}_i" : k
        self.send(msg).casecmp(other.send(msg)) == 0
      end
    else
      false
    end
  end
  
  PARSE_FORMATS = [:first_middle_last, :last_first_middle, :auto_detect]
  OUTPUT_FORMATS = [:first, :middle, :last, :full, :full_reverse, :first_space_last, :last_space_first, :last_comma_first, :last_comma_space_first]

  private

  def self.blank?(string_or_nil)
    string_or_nil.nil? || string_or_nil !~ /\S/
  end
  
  def self.normalize_suffix(suffix)
    suffix.match(/\w+/)[0] rescue suffix
  end
  
  SUPPORTED_PARTS = [:first,:middle,:last, :suffix]
  SUPPORTED_SUFFIXES = %w(II III IV V JR JR. SR SR.)
  ODD_LAST_NAME_PREFIXES = %w(MC ST ST.)
end
