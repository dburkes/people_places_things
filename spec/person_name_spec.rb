require 'spec/helper'

describe PersonName do
  it "should parse first_middle_last" do
    name = PersonName.parse "george quincy drake peabody", :first_middle_last
    name.first.should == 'george'
    name.middle.should == 'quincy drake'
    name.last.should == 'peabody'
  end
  
  it "should parse last_first_middle" do
    name = PersonName.parse "peabody george quincy drake", :last_first_middle
    name.first.should == 'george'
    name.middle.should == 'quincy drake'
    name.last.should == 'peabody'
  end
  
  it "should parse last only in first_middle_last format" do
    name = PersonName.parse "peabody", :first_middle_last
    name.first.should == nil
    name.middle.should == nil
    name.last.should == 'peabody'
  end
  
  it "should parse last only in last_first_middle format" do
    name = PersonName.parse "peabody", :last_first_middle
    name.first.should == nil
    name.middle.should == nil
    name.last.should == 'peabody'
  end
  
  it "should parse first middle last suffix" do
    name = PersonName.parse "george f. peabody jr"
    name.first.should == 'george'
    name.middle.should == 'f.'
    name.last.should == 'peabody'
    name.suffix.should == 'jr'
  end

  it "should parse last suffix first middle" do
    name = PersonName.parse "peabody jr george f.", :last_first_middle
    name.first.should == 'george'
    name.middle.should == 'f.'
    name.last.should == 'peabody'
    name.suffix.should == 'jr'
  end
  
  it "should default to first_middle_last" do
    name = PersonName.parse "george quincy drake peabody"
    name.first.should == 'george'
    name.middle.should == 'quincy drake'
    name.last.should == 'peabody'
  end
  
  it "should ignore spaces and commas" do
    name = PersonName.parse "  peabody,george  quincy       drake ", :last_first_middle
    name.first.should == 'george'
    name.middle.should == 'quincy drake'
    name.last.should == 'peabody'
  end
  
  it "should strip periods from initials" do 
    name = PersonName.parse "george f. peabody", :first_middle_last
    name.first.should == 'george'
    name.middle.should == 'f.'
    name.middle_i == 'f'
    name.last.should == 'peabody'
  end
  
  it "should format for :first" do
    name = PersonName.new :first => 'george', :middle => 'quincy', :last => 'peabody'
    name.to_s(:first).should == 'george'
  end
  
  it "should format for :middle" do
    name = PersonName.new :first => 'george', :middle => 'quincy', :last => 'peabody'
    name.to_s(:middle).should == 'quincy'
  end
  
  it "should format for :last" do
    name = PersonName.new :first => 'george', :middle => 'quincy', :last => 'peabody'
    name.to_s(:last).should == 'peabody'
  end
  
  it "should format for :full" do
    name = PersonName.new :first => 'george', :middle => 'quincy', :last => 'peabody'
    name.to_s(:full).should == 'george quincy peabody'
  end

  it "should format for :full_reverse" do
    name = PersonName.new :first => 'george', :middle => 'quincy', :last => 'peabody', :suffix => 'jr.'
    name.to_s(:full_reverse).should == 'peabody george quincy jr.'
  end
  
  it "should format for :first_space_last" do
    name = PersonName.new :first => 'george', :middle => 'quincy', :last => 'peabody'
    name.to_s(:first_space_last).should == 'george peabody'
  end
  
  it "should format for :last_space_first" do
    name = PersonName.new :first => 'george', :middle => 'quincy', :last => 'peabody'
    name.to_s(:last_space_first).should == 'peabody george'
  end
  
  it "should format for :last_comma_first" do
    name = PersonName.new :first => 'george', :middle => 'quincy', :last => 'peabody'
    name.to_s(:last_comma_first).should == 'peabody,george'
  end
  
  it "should format for :last_comma_space_first" do
    name = PersonName.new :first => 'george', :middle => 'quincy', :last => 'peabody'
    name.to_s(:last_comma_space_first).should == 'peabody, george'
  end
  
  it "should handle missing parts when formatting" do 
    PersonName.new({ :last => 'peabody' }).to_s(:last_comma_space_first).should == 'peabody'
  end
  
  it "should respond to index method" do
    name = PersonName.new :first => 'george', :middle => 'quincy', :last => 'peabody'
    name[:first].should == 'george'
    name[:middle].should == 'quincy'
    name[:last].should == 'peabody'
  end
  
  it "should respond to individual accessors" do 
    name = PersonName.new :first => 'george', :middle => 'quincy', :last => 'peabody'
    name.first.should == 'george'
    name.first_i.should == 'g'
    name.middle.should == 'quincy'
    name.middle_i.should == 'q'
    name.last.should == 'peabody'
    name.last_i.should == 'p'
  end
  
  it "should recognize exact equality" do
    PersonName.parse("george quincy peabody").should be_eql(PersonName.parse("george quincy peabody"))
  end

  it "should ignore case for equality" do
    PersonName.parse("george quincy peabody").should be_eql(PersonName.parse("george quincy PEABODY"))
  end
  
  it "should recognize subset equality" do
    PersonName.parse("george quincy peabody").should be_eql(PersonName.parse("george peabody"))
  end
  
  it "should parse mc donald for first_middle_last" do
    name = PersonName.parse "george quincy drake mc donald", :first_middle_last
    name.first.should == 'george'
    name.middle.should == 'quincy drake'
    name.last.should == 'mcdonald'
  end
  
  it "should parse mc donald for last_first_middle" do
    name = PersonName.parse "mc donald george quincy drake", :last_first_middle
    name.first.should == 'george'
    name.middle.should == 'quincy drake'
    name.last.should == 'mcdonald'
  end
  
  it "should normalize suffixes" do
    name = PersonName.parse "george quincy peabody jr"
    name2 = PersonName.parse "peabody jr., george quincy", :last_first_middle
    name.should be_eql(name2)
  end
  
  it "should support auto detect formatting for first_middle_last" do
    name = PersonName.parse "george f. peabody jr"
    name.first.should == 'george'
    name.middle.should == 'f.'
    name.last.should == 'peabody'
    name.suffix.should == 'jr'
  end
  
  it "should support auto detect formatting for last_first_middle" do
    name = PersonName.parse "peabody, george quincy drake"
    name.first.should == 'george'
    name.middle.should == 'quincy drake'
    name.last.should == 'peabody'
  end
end
