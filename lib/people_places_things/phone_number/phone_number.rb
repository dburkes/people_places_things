class PhoneNumber
  @@SUPPORTED_PARTS = [:country_code, :area_code, :number, :exchange, :suffix]
  @@SUPPORTED_PARTS.each {|attr| attr_accessor attr}
  attr_accessor :raw
  
  def initialize(parts={})
    parts.keys.each do |k|
      send("#{k}=", parts[k]) if @@SUPPORTED_PARTS.include?(k)
    end
    
    raise "Unsupported Format" if !self.exchange || !self.suffix
  end
  
  def self.parse(string)
    extract = string.strip.match(/^([-+()\d ]+)$/)[0].gsub(/[^\d]/, '') rescue nil
    raise "Unsupported Format" if !extract || extract.length < 10 || extract.length > 11

    parts = {}
    
    if extract.length == 11
      parts[:country_code] = extract.slice!(0..0)
    else
      parts[:country_code] = '1'
    end
    
    raise "Unsupported Format" if parts[:country_code] != '1'
    
    parts[:area_code] = extract.slice!(0..2)
    
    parts[:number] = extract.dup

    parts[:exchange] = extract.slice!(0..2)
    
    parts[:suffix] = extract
    
    ret = PhoneNumber.new parts
    ret.raw = string
    ret
  end
  
  def self.format(parts, fmt)
    PhoneNumber.new(parts).to_s(fmt)
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