require 'spec_helper'

describe Middleman::RootNestedNavItem do

  it "should not have a parent" do
    subject.parent.should be_nil
  end

  it "should have a server relative path" do
    subject.path.should eq '/'
  end

  it "should include index in its sub pages" do
    index = Middleman::NestedNavItem.new('Home', 'index.html')
    subject << index
    subject.sub_pages.should eq [index]
  end

end
