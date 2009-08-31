require 'spec/helper'

describe State do
  it "should parse abbreviation" do
    state = State.new 'ga'
    state.sym.should == :ga
  end

  it "should parse full" do
    state = State.new 'georgia'
    state.sym.should == :ga
  end

  it "should throw exception on unsupported state" do
    lambda { State.new('foo') }.should raise_error
  end

  it "should format :abbr" do 
    State.new('ga').to_s(:abbr).should == 'GA'
  end

  it "should format :full" do 
    State.new('ga').to_s(:full).should == 'Georgia'
  end

  it "should throw exception on unsupported to_s format" do
    lambda { State.new('ga').to_s(:bogus) }.should raise_error
  end
end
