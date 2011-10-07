require 'spec_helper'

describe StreetAddress do
  it "should parse number street" do
    addr = StreetAddress.new "123 Main Street"
    addr.number.should == '123'
    addr.name.should == 'Main'
    addr.suffix.should == :street
  end
  
  it "should parse number with letter" do
    addr = StreetAddress.new "204-B Main Street"
    addr.number.should == '204-B'
    addr.name.should == 'Main'
    addr.suffix.should == :street
  end
  
  it "should parse pre direction" do 
    addr = StreetAddress.new "123 E Main Street"
    addr.number.should == '123'
    addr.pre_direction.should == :east
    addr.name.should == 'Main'
    addr.suffix.should == :street
  end

  it "should parse post direction" do 
    addr = StreetAddress.new "123 Main Street NE"
    addr.number.should == '123'
    addr.name.should == 'Main'
    addr.suffix.should == :street
    addr.post_direction.should == :northeast
  end
  
  it "should parse pre and post direction" do 
    addr = StreetAddress.new "123 E Main Street North"
    addr.number.should == '123'
    addr.pre_direction.should == :east
    addr.name.should == 'Main'
    addr.suffix.should == :street
    addr.post_direction.should == :north
  end
  
  it "should parse street names that look like directions" do 
    addr = StreetAddress.new "123 E E St"
    addr.number.should == '123'
    addr.pre_direction.should == :east
    addr.name.should == 'E'
    addr.suffix.should == :street
  end

  it "should parse street names that look like directions, with post directions" do 
    addr = StreetAddress.new "123 E E St NE"
    addr.number.should == '123'
    addr.pre_direction.should == :east
    addr.name.should == 'E'
    addr.suffix.should == :street
    addr.post_direction.should == :northeast
  end
  
  it "should parse abbreviations" do 
    addr = StreetAddress.new "123 e. 1st ave"
    addr.number.should == '123'
    addr.pre_direction.should == :east
    addr.name.should == '1st'
    addr.ordinal.should == '1st'
    addr.suffix.should == :avenue
  end
  
  it "should parse ordinal and name" do
    addr = StreetAddress.new "123 1st East ave"
    addr.number.should == '123'
    addr.name.should == '1st East'
    addr.ordinal.should == '1st'
    addr.suffix.should == :avenue    
  end
  
  it "should parse suites" do
    addr = StreetAddress.new "123 E E St NE Ste 23"
    addr.number.should == '123'
    addr.pre_direction.should == :east
    addr.name.should == 'E'
    addr.suffix.should == :street
    addr.post_direction.should == :northeast
    addr.unit_type.should == :suite
    addr.unit.should == '23'
  end

  it "should parse apartments" do
    addr = StreetAddress.new "123 E E St NE Apartment 4"
    addr.number.should == '123'
    addr.pre_direction.should == :east
    addr.name.should == 'E'
    addr.suffix.should == :street
    addr.post_direction.should == :northeast
    addr.unit_type.should == :apartment
    addr.unit.should == '4'
  end
  
  it "should parse numbers" do
    addr = StreetAddress.new '123 E E St NE # 5'
    addr.number.should == '123'
    addr.pre_direction.should == :east
    addr.name.should == 'E'
    addr.suffix.should == :street
    addr.post_direction.should == :northeast
    addr.unit_type.should == :number
    addr.unit.should == '5'
  end
  
  it "should parse no number" do 
    addr = StreetAddress.new "Westside Highway"
    addr.number.should == nil
    addr.name.should == 'Westside'
    addr.suffix.should == :highway
  end

  it "should parse directional street with suffix" do 
    addr = StreetAddress.new "12 north avenue"
    addr.number.should == '12'
    addr.name.should == 'north'
    addr.suffix.should == :avenue
  end
  
  it "should parse directional street without suffix" do 
    addr = StreetAddress.new "12 north"
    addr.number.should == '12'
    addr.name.should == 'north'
  end

  it "should parse directional street with postdir" do 
    addr = StreetAddress.new "12 north w"
    addr.number.should == '12'
    addr.name.should == 'north'
    addr.post_direction.should == :west
  end
  
  it "should parse directional street with postdir and unit" do 
    addr = StreetAddress.new "12 n sw apt. 2"
    addr.number.should == '12'
    addr.name.should == 'n'
    addr.post_direction.should == :southwest
    addr.unit_type.should == :apartment
    addr.unit.should == '2'
  end
  
  it "should handle commas" do
    addr = StreetAddress.new "123 E E St NE, suite 23"
    addr.number.should == '123'
    addr.pre_direction.should == :east
    addr.name.should == 'E'
    addr.suffix.should == :street
    addr.post_direction.should == :northeast
    addr.unit_type.should == :suite
    addr.unit.should == '23'
  end
  
  it "should support long form" do
    StreetAddress.string_for(:northwest, :long).should == 'northwest'
  end
  
  it "should support short form" do
    StreetAddress.string_for(:road, :short).should == 'rd'
  end
  
  it "should support short form when none exists" do
    StreetAddress.string_for(:oaks, :short).should == StreetAddress.string_for(:oaks, :long)
  end
  
  # make sure PO box processing doesn't change original name
  it "should output PO box in to_s" do
    addr = StreetAddress.new "PO Box 111"
    addr.to_s.should == "PO Box 111"
    addr.name.should == "PO Box 111"
    addr.box_number.should == '111'
  end
  
  it "should parse box_number" do
    addr = StreetAddress.new "PO BOX 111"
    addr.box_number.should == "111"
  end
  
  it "should handle postal standards" do
    addr = StreetAddress.new "100 Back ALY"
    addr.suffix.should == :alley
  end
  
  it "should output postal standard ordinals" do
    addr = StreetAddress.new "100 First St"
    addr.to_canonical_s.should == "100 1ST ST"
  end
  
  it "should output postal standard" do
    addr = StreetAddress.new "100 East Woodside Crossing S.W."
    addr.to_canonical_s.should == "100 E WOODSIDE XING SW"
  end
  
  it "should remove punctuation in canoncial and keep it in to_s" do
    addr = StreetAddress.new %q!100 Avenue of the America's!
    addr.to_canonical_s.should == %q!100 AVENUE OF THE AMERICAS!    
    addr.to_s.should == %q!100 Avenue of the America's!
  end
  
  it "should output unit as canoncial" do
    addr = StreetAddress.new %q!100 Main suite 13!
    addr.to_canonical_s.should == %q!100 MAIN # 13!
    addr = StreetAddress.new %q!100 Main suite # 13!
    addr.to_canonical_s.should == %q!100 MAIN # 13!
  end
  
  it "should output Rural Route" do
    addr = StreetAddress.new "RR 3 Box 9"
    addr.to_canonical_s.should == "RR 3 BOX 9"
  end
  
  it "should parse and output PO Box" do
    addr = StreetAddress.new "P.O. Box 1234"
    addr.to_canonical_s.should == 'PO BOX 1234'
    addr.to_s.should == 'P.O. Box 1234'
    addr.valid?.should be_true
  end
  
  it "should parse and output Post Office Box with dash in box number" do
    addr = StreetAddress.new "Post Office Box 1234-A"
    addr.to_canonical_s.should == 'PO BOX 1234-A'
    addr.name.should == "Post Office Box 1234-A"
    addr.box_number.should == '1234-A'
    addr.valid?.should be_true    
  end
  
  it "should parse and output p o box format" do
    addr = StreetAddress.new "p o box 1234"
    addr.to_canonical_s.should == 'PO BOX 1234'
    addr.name.should == "p o box 1234"
    addr.box_number.should == '1234'
    addr.valid?.should be_true    
  end

  it "should parse and output PO Box with #" do
    addr = StreetAddress.new "PO Box #1234"
    addr.to_canonical_s.should == 'PO BOX 1234'
    addr.name.should == "PO Box #1234"
    addr.box_number.should == '1234'
    addr.valid?.should be_true
  end
  
  it "should handle Number and PO Box" do
    addr = StreetAddress.new "100 Main P.O. Box 1234"
    addr.to_canonical_s.should == '100 MAIN PO BOX 1234'
    addr.to_s.should == '100 Main P.O. Box 1234' 
  end
  
  it "should ignore whitespace" do
    addr = StreetAddress.new " 100  E.  Woodside "
    addr.to_canonical_s.should == "100 E WOODSIDE"    
  end
  
  it "should allow empty" do
    addr = StreetAddress.new " "
    addr.to_canonical_s.empty?.should == true
  end
  
  it "should be valid with number and name" do
    addr = StreetAddress.new "100 main st."
    addr.valid?.should == true
  end

  it "should not be valid if blank" do
    addr = StreetAddress.new ""
    addr.valid?.should == false
  end
  
  it "should not be valid with name only" do
    addr = StreetAddress.new "main st."
    addr.valid?.should == false    
  end
  
  it "should not be valid with PO Box name and no box number" do
    addr = StreetAddress.new "PO Box."
    addr.valid?.should == false    
  end
  
  it "should not be valid with number only" do
    addr = StreetAddress.new "100"
    addr.valid?.should == false    
  end
    
  it "should not be valid with a name followed by a number" do
    addr = StreetAddress.new "main st. 100"
    addr.valid?.should == false    
  end

  it "should be valid for a Rural Route and box number" do
    addr = StreetAddress.new "R.R. 3 Box 100"
    addr.to_canonical_s.should == 'RR 3 BOX 100'
    addr.valid?.should == true        
  end
  
  it "should be valid for a Rural Route # and box number" do
    addr = StreetAddress.new "RR #3 Box 100"
    addr.to_canonical_s.should == "RR 3 BOX 100"
    addr.valid?.should == true        
  end  
    
  it "should be valid for a Rural Route with a # and remove punctuation" do
    addr = StreetAddress.new "R.R. #3 Box #100-A.,"
    addr.box_number.should == '100-A'
    addr.to_canonical_s.should == "RR 3 BOX 100-A"
    addr.valid?.should == true        
  end
  
  it "should save raw" do
    StreetAddress.new('123 Main st.').raw.should == '123 Main st.'
  end
end
