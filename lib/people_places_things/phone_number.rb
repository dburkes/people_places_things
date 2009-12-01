module PeoplePlacesThings
  class PhoneNumber
    attr_accessor :country_code, :area_code, :number, :exchange, :suffix, :raw
  
    def initialize(str)
      self.raw = str
      extract = str.strip.match(/^([-+()\d ]+)$/)[0].gsub(/[^\d]/, '') rescue nil
      raise "Unsupported Format" if !extract || extract.length < 10 || extract.length > 11

      if extract.length == 11
        self.country_code = extract.slice!(0..0)
      else
        self.country_code = '1'
      end
    
      raise "Unsupported Format" if self.country_code != '1'
    
      self.area_code = extract.slice!(0..2)
    
      self.number = extract.dup

      self.exchange = extract.slice!(0..2)
    
      self.suffix = extract

      raise "Unsupported Format" if !self.exchange || !self.suffix
    end
  
    def to_s(fmt = :full_formatted)
      raise "Unsupported Format" if !OUTPUT_FORMATS.include?(fmt)

      case fmt
        when :full_digits
          "#{self.country_code}#{self.area_code}#{self.exchange}#{self.suffix}"
        
        when :local_digits
          "#{self.exchange}#{self.suffix}"
        
        when :full_formatted
          "#{self.country_code} (#{self.area_code}) #{self.exchange}-#{self.suffix}"
        
        when :local_formatted
          "#{self.exchange}-#{self.suffix}"
      end
    end
  
    OUTPUT_FORMATS = [:full_digits, :local_digits, :full_formatted, :local_formatted]
  end
end