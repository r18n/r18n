# encoding: utf-8
require File.join(File.dirname(__FILE__), 'spec_helper')

describe R18n::Filters do
  before do
    @i18n = R18n::I18n.new('en', DIR)
    R18n.call_proc = true
  end
  
  it "should add new filter" do
    R18n::Filters.add(:my) { |i, locale| i }
    
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
  
  it "should send locale to filter" do
    R18n::Filters.add(:my) { |i, locale| locale }
    @i18n.my_filter.should == @i18n.locale
  end
  
  it "should send parameters to filter" do
    R18n::Filters.add(:my) { |i, locale, a, b| "#{i}#{a}#{b}" }
    @i18n.my_filter(1, 2).should == 'value12'
  end

  it "should call proc from translation" do
    @i18n.sum(2, 3).should == 5
  end
  
  it "shouldn't call proc if it isn't secure" do
    R18n.call_proc = false
    R18n.call_proc.should be_false
    @i18n.sum(2, 3).should == '|x, y| x + y'
  end

  it "should pluralize translation" do
    @i18n.comments(0, 'article').should == 'no comments for article'
    @i18n.comments(1, 'article').should == 'one comment for article'
    @i18n.comments(5, 'article').should == '5 comments for article'
    
    @i18n.files(0).should == '0 files'
    @i18n.files(-5.5).should == '−5.5 files'
    @i18n.files(5000).should == '5,000 files'
  end

  it "should pluralize translation without locale" do
    i18n = R18n::I18n.new('no_LC', DIR)
    i18n.entries(1).should == 'ONE'
    i18n.entries(5).should == 'N'
  end
  
end
