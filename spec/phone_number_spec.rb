require 'spec/helper'

describe PhoneNumber do
  it "should parse ten digits" do
    phone = PhoneNumber.new '4045551212'
    phone.area_code.should == '404'
    phone.number.should == '5551212'
    phone.exchange.should == '555'
    phone.suffix.should == '1212'
  end

  it "should parse eleven digits" do
    phone = PhoneNumber.new '14045551212'
    phone.area_code.should == '404'
    phone.number.should == '5551212'
    phone.exchange.should == '555'
    phone.suffix.should == '1212'
  end
  
  it "should ignore certain characters" do
    phone = PhoneNumber.new '1 (404) 555-1212'
    phone.area_code.should == '404'
    phone.number.should == '5551212'
    phone.exchange.should == '555'
    phone.suffix.should == '1212'
  end
  
  it "should support international format, at least for US numbers, for now" do
    phone = PhoneNumber.new '+1 404 555-1212'
    phone.area_code.should == '404'
    phone.number.should == '5551212'
    phone.exchange.should == '555'
    phone.suffix.should == '1212'
  end
  
  it "should throw exception on unsupported parse format" do
    lambda { PhoneNumber.new('40455512') }.should raise_error
  end
  
  it "should format :full_digits" do
    PhoneNumber.new('14045551212').to_s(:full_digits).should == '14045551212'
  end

  it "should format :local_digits" do
    PhoneNumber.new('14045551212').to_s(:local_digits).should == '5551212'
  end

  it "should format :full_formatted" do
    PhoneNumber.new('14045551212').to_s(:full_formatted).should == '1 (404) 555-1212'
  end

  it "should format :local_formatted" do
    PhoneNumber.new('14045551212').to_s(:local_formatted).should == '555-1212'
  end

  it "should throw exception on unsupported to_sformat" do
    lambda { PhoneNumber.new('14045551212').to_s(:bogus) }.should raise_error
  end
  
  it "should save raw" do
    PhoneNumber.new('14045551212').raw.should == '14045551212'
  end
end
