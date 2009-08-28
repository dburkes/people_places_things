class PhoneNumber
  @@SUPPORTED_PARTS = [:country_code, :area_code, :number, :exchange, :suffix]
  @@SUPPORTED_PARTS.each {|attr| attr_accessor attr}
  attr_accessor :raw
  
  def initialize(parts={})
    parts.keys.each do |k|
      send("#{k}=", parts[k]) if @@SUPPORTED_PARTS.include?(k)
    end
  end
  
  def self.parse(string)
    extract = string.match(/.*?([-()\d ]+)/)[1].gsub(/[^\d]/, '') rescue nil
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
end