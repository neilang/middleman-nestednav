require 'spec_helper'


describe Middleman::NestedNavItem do

  subject { Middleman::NestedNavItem.new '', '/' }

  it { should respond_to :title }
  it { should respond_to :path }
  it { should respond_to :children }
  it { should respond_to :parent }
  it { should respond_to :each }

  it "should set the parent when using <<" do
    nav_item = Middleman::NestedNavItem.new '', '/'
    nav_item << subject
    subject.parent.should eq nav_item
  end

  it "should know if it has no children" do
    nav_item = Middleman::NestedNavItem.new '', '/'
    nav_item.children?.should be_false
  end

  it "should know if it does have children" do
    nav_item = Middleman::NestedNavItem.new '', '/'
    nav_item << subject
    nav_item.children?.should be_true
  end

  it "should know if it is the root" do
    subject.root?.should be_true
  end

  it "should know if it is not the root" do
    nav_item = Middleman::NestedNavItem.new '', '/'
    nav_item << subject
    subject.root?.should be_false
  end

  describe "recursive create" do
    let(:root){ Middleman::RootNestedNavItem.new }

    it "should create a child element" do
      nav = root
      Middleman::NestedNavItem.recursively_create(nav, 'Test', 'about.html')
      nav.children.size.should eq 1
    end

    it "should create a nested child element" do
      nav = root
      Middleman::NestedNavItem.recursively_create(nav, 'Test', 'foo/about.html')
      nav['foo'].children.size.should eq 1
    end

  end

end
