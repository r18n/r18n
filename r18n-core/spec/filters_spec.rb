# encoding: utf-8
require File.join(File.dirname(__FILE__), 'spec_helper')

describe R18n::Filters do
  before do
    @i18n = R18n::I18n.new('en', DIR)
  end
  
  it "should add new filter" do
    R18n::Filters.add(:my) { |i| i }
    
    R18n::Filters.defined.should have_key('my')
    @i18n.my_filter.should == 'value'
    @i18n.my_tree_filter.should == {'name' => 'value'}
  end
  
  it "should reset filter" do
    R18n::Filters.add(:my) { 1 }
    @i18n.my_filter.should == 1
    
    R18n::Filters.add(:my) { 'a' }
    @i18n.my_filter.should == 'a'
  end
  
  it "should raise error on unknown filter" do
    lambda {
      @i18n.unknown_filter
    }.should raise_error(ArgumentError, "Unknown filter 'unknown'")
  end
  
  it "should delete filter" do
    R18n::Filters.add(:my) { '1' }
    @i18n.my_filter.should == '1'
    
    R18n::Filters.delete(:my)
    R18n::Filters.defined.should_not have_key('my')
    lambda { @i18n.my_filter }.should raise_error
  end
  
  it "should send parameters to filter" do
    R18n::Filters.add(:my) { |i, a, b| "#{i}#{a}#{b}" }
    @i18n.my_filter(1, 2).should == 'value12'
  end
  
end
