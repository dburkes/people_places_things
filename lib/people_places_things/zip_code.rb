module PeoplePlacesThings
  class ZipCode
    attr_accessor :base, :plus_four, :raw
  
    def initialize(str)
      tokens = str.strip.match(/^(\d{5})(-\d{4})?$/)[0].split('-') rescue nil
      raise "Unsupported Format" if !tokens

      self.base = tokens.first
      self.plus_four = tokens[1] rescue nil
    end
  
    def to_s
      [self.base, self.plus_four].compact.join('-')
    end
  end
end