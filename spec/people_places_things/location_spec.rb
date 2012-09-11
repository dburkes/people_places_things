require 'spec_helper'

describe Location do
  it "should parse city" do
    test_location("san francisco", "san francisco", nil, nil)
  end

  it "should parse city state abbreviation" do
    test_location("san francisco ca", "san francisco", "CA", nil)
  end
  
  it "should parse city comma state abbr" do
    test_location("marlboro, nj", "marlboro", "NJ", nil)
  end

  it "should parse city state full" do
    test_location("san francisco california", "san francisco", "CA", nil)
  end

  it "should parse city comma state" do
    test_location("san francisco, ca", "san francisco", "CA", nil)
  end
  
  it "should parse city comma full state" do
    test_location("new york, new york", "new york", "NY", nil)
  end
  
  it "should parse city comma full state zip" do
    test_location("new york, new york 10016", "new york", "NY", "10016")
  end
  
  it "should parse city full state zip" do
    test_location("new york new york 10016", "new york", "NY", "10016")
  end
  
  it "should parse city state zip" do
    test_location("san francisco ca 94114-1212", "san francisco", "CA", '94114-1212')
  end

  it "should parse city comma state zip" do
    test_location("san francisco, ca 94114-1212", "san francisco", "CA", '94114-1212')
  end
  
  it "should parse city zip" do
    test_location("san francisco 94114-1212", "san francisco", nil, '94114-1212')
  end
  
  it "should parse state zip" do
    test_location("ca 94114-1212", nil, "CA", '94114-1212')
  end
  
  it "should parse state" do
    test_location("california", nil, "CA", nil)
  end
  
  it "should parse zip" do
    test_location("94114-1212", nil, nil, '94114-1212')
  end
  
  it "should save raw" do 
    Location.new('san francisco, ca').raw.should == 'san francisco, ca'
  end
  
  private
  
  def test_location(str, city, state, zip)
    l = Location.new(str)
    l.city.should == city if l.city
    l.state.to_s(:abbr).should == state.upcase if l.state
    l.zip.to_s.should == zip if l.zip
  end
end
