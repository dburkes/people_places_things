class ZipCode
  @@SUPPORTED_PARTS = [:base, :plus_four]
  @@SUPPORTED_PARTS.each {|attr| attr_accessor attr}
  attr_accessor :raw
  
  def initialize(parts={})
    parts.keys.each do |k|
      send("#{k}=", parts[k]) if @@SUPPORTED_PARTS.include?(k)
    end
  end
  
  def self.parse(string)
    tokens = string.strip.match(/^(\d{5})(-\d{4})?$/)[0].split('-') rescue nil
    raise "Unsupported Format" if !tokens

    parts = {}
    parts[:base] = tokens.first
    parts[:plus_four] = tokens[1] rescue nil
    
    ret = ZipCode.new parts
    ret.raw = string
    ret
  end
  
  def self.format(parts, fmt)
    ZipCode.new(parts).to_s(fmt)
  end
  
  def to_s(fmt = :plus_four)
    raise "Unsupported Format" if !OUTPUT_FORMATS.include?(fmt)

    case fmt
      when :base
        self.base
        
      when :plus_four
        [self.base, self.plus_four].compact.join('-')
    end
  end
  
  OUTPUT_FORMATS = [:base, :plus_four]
end