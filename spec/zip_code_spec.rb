require 'spec/helper'

describe ZipCode do
  it "should parse base" do
    zip = ZipCode.parse '30306'
    zip.base.should == '30306'
    zip.plus_four.should == nil
  end

  it "should parse plus four" do
    zip = ZipCode.parse '30306-3522'
    zip.base.should == '30306'
    zip.plus_four.should == '3522'
  end

  it "should throw exception on unsupported parse format" do
    lambda { ZipCode.parse('303065344') }.should raise_error
  end

  it "should format :base" do 
    ZipCode.parse('30306-3522').to_s(:base).should == '30306'
  end

  it "should format :plus_four" do 
    ZipCode.parse('30306-3522').to_s(:plus_four).should == '30306-3522'
  end

  it "should throw exception on unsupported to_s format" do
    lambda { ZipCode.parse('30306-3522').to_s(:bogus) }.should raise_error
  end
end
