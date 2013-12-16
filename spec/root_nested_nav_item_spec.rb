require 'spec_helper'

describe Middleman::RootNestedNavItem do

  it "should not have a parent" do
    subject.parent.should be_nil
  end

  it "should have a server relative path" do
    subject.path.should eq '/'
  end

end
