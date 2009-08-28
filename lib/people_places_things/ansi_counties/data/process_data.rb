require 'csv'
require 'yaml'
require '../../ansi-counties'

class ANSIDataProcessor  #:nodoc:
  def self.run(in_filename, out_filename)
    rownum = 0
    data = {}
    
    CSV::Reader.parse(File.open(in_filename, 'rb')) do |row|
      puts "processing row #{rownum}" if (rownum % 500) == 0
      
      if rownum > 0 && row.length == 5
        state = row[0].strip
        ansi = row[1].strip
        code = row[2].strip
        county = ANSICounties.normalize_county_name(row[3].strip)
        
        key = ANSICounties.key_for(state, county)
        value = "#{ansi.to_s}#{code.to_s}".to_i
        data[key] = value
      end
      
      rownum += 1
    end
    
    File.open(out_filename, 'wb') do |file|
      YAML.dump(data, file)
    end
  end
end

ANSIDataProcessor.run(ARGV[0], ARGV[1])