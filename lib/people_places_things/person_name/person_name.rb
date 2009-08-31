class PersonName
  attr_accessor :first, :middle, :last, :suffix, :raw

  def initialize(str, fmt = :auto_detect)
    raise "Unsupported Format" if !PARSE_FORMATS.include?(fmt)
    
    if fmt == :auto_detect
      fmt = str.include?(',') ? :last_first_middle : :first_middle_last
    end
    
    self.raw = str
    
    parts = str.split(/\s|,/).collect {|p| p.strip}.reject {|p| PersonName.blank?(p) || p == ',' }
  
    if parts.size == 1
      self.last = parts.first
    else
      case fmt
        when :first_middle_last
          if parts.size > 2 and SUPPORTED_SUFFIXES.detect {|s| s.casecmp(parts.last) == 0}
            self.suffix = PersonName.normalize_suffix(parts.last)
            parts.delete_at(parts.size - 1)
          end
        
          self.first = parts.first if parts.size > 0
          self.last = parts.last if parts.size > 1
        
          if parts.size > 2 && ODD_LAST_NAME_PREFIXES.detect {|s| s.casecmp(parts[-2]) == 0}
            self.last = "#{parts[-2]}#{self.last}"
            parts.delete_at(parts.size - 2)
          end
            
          self.middle = parts[1..(parts.size - 2)].join(' ') if parts.size > 2
    
        when :last_first_middle
          self.last = parts.first if parts.size > 0
        
          if parts.size > 1 && ODD_LAST_NAME_PREFIXES.detect {|s| s.casecmp(self.last) == 0}
            self.last << parts[1]
            parts.delete_at(1)
          end

          if parts.size > 2 and SUPPORTED_SUFFIXES.detect {|s| s.casecmp(parts[1]) == 0}
            self.suffix = PersonName.normalize_suffix(parts[1])
            parts.delete_at(1)
          end

          self.first = parts[1] if parts.size > 1
          self.middle = parts[2..(parts.size - 1)].join(' ') if parts.size > 2
      end
    end
  end
  
  def to_s(fmt = :full)
    raise "Unsupported Format" if !OUTPUT_FORMATS.include?(fmt)

    case fmt
      when :first, :middle, :last
        self.send(fmt)
      
      when :full
        [self.first, self.middle, self.last, self.suffix].compact.join(' ')
        
      when :full_reverse
        [self.last, self.first, self.middle, self.suffix].compact.join(' ')
      
      when :first_space_last
        [self.first, self.last].compact.join(' ')
      
      when :last_space_first
        [self.last, self.first].compact.join(' ')
      
      when :last_comma_first
        [self.last, self.first].compact.join(',')
      
      when :last_comma_space_first
        [(self.first ? "#{self.last}," : self.last), self.first].compact.join(' ')
    end
  end

  def first_i
    self.first[0,1] rescue nil
  end

  def middle_i
    self.middle[0,1] rescue nil
  end

  def last_i
    self.last[0,1] rescue nil
  end
  
  def eql?(other, initials_only=false)
    if other.is_a?(PersonName)
      [:first, :middle, :last].all? do |k|
        msg = (k != :last && initials_only) ? "#{k}_i" : k
        me = self.send(msg)
        them = other.send(msg)
        me && them ? me.casecmp(them) == 0 : true
      end
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
  
  SUPPORTED_SUFFIXES = %w(II III IV V JR JR. SR SR.)
  ODD_LAST_NAME_PREFIXES = %w(MC ST ST.)
end
