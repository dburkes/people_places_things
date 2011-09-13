require 'spec_helper'

describe ZipCode do
  it "should parse base" do
    zip = ZipCode.new '30306'
    zip.base.should == '30306'
    zip.plus_four.should == nil
  end

  it "should parse plus four" do
    zip = ZipCode.new '30306-3522'
    zip.base.should == '30306'
    zip.plus_four.should == '3522'
  end
  
  it "should throw exception on unsupported parse format" do
    lambda { ZipCode.new('303065344') }.should raise_error
  end

  it "should convert to string" do 
    ZipCode.new('30306-3522').to_s.should == '30306-3522'
  end

  it "should throw exception on unsupported to_s format" do
    lambda { ZipCode.new('30306-3522').to_s(:bogus) }.should raise_error
  end
  
  it "should save raw format" do
    ZipCode.new('30306-3522').raw.should == '30306-3522'
  end
end
