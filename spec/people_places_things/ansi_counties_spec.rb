require 'spec_helper'

describe ANSICounties do
  it "should find code for valid state and county" do
    ANSICounties.code_for('ga', 'fulton').should == 13121
  end
  
  it "should find code for valid state and county hash" do
    ANSICounties.code_for(:state => 'ga', :county => 'fulton').should == 13121
  end
  
  it "should return nil for invalid state and county" do
    ANSICounties.code_for(:state => 'ga', :county => 'fubar').should == nil
  end
  
  it "should find code for alternate st. form" do
    ANSICounties.code_for(:state => 'MO', :county => 'saint LOUIS').should == 29510
  end
  
  it "should find data for valid code" do 
    ANSICounties.data_for(13121).should == { :state => 'GA', :county => 'FULTON' }
  end
  
  it "should return nil for invalid code" do 
    ANSICounties.data_for(1312111).should == nil
  end
end