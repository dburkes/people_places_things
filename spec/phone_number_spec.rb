require 'spec/helper'

describe PhoneNumber do
  it "should parse ten digits" do
    phone = PhoneNumber.parse '4045551212'
    phone.area_code.should == '404'
    phone.number.should == '5551212'
    phone.exchange.should == '555'
    phone.suffix.should == '1212'
  end

  it "should parse eleven digits" do
    phone = PhoneNumber.parse '14045551212'
    phone.area_code.should == '404'
    phone.number.should == '5551212'
    phone.exchange.should == '555'
    phone.suffix.should == '1212'
  end
  
  it "should ignore certain characters" do
    phone = PhoneNumber.parse '1 (404) 555-1212'
    phone.area_code.should == '404'
    phone.number.should == '5551212'
    phone.exchange.should == '555'
    phone.suffix.should == '1212'
  end
  
  it "should support international format, at least for US numbers, for now" do
    phone = PhoneNumber.parse '+1 404 555-1212'
    phone.area_code.should == '404'
    phone.number.should == '5551212'
    phone.exchange.should == '555'
    phone.suffix.should == '1212'
  end
  
  it "should throw exception on unsupported format" do
    lambda { PhoneNumber.parse('40455512') }.should raise_error
  end
end
