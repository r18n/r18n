# encoding: utf-8
require File.join(File.dirname(__FILE__), 'spec_helper')

describe R18n::Backend do
  before do
    I18n.load_path = [GENERAL]
    I18n.backend = R18n::Backend.new
    R18n.set R18n::I18n.new('en', R18n::Loader::Rails.new)
  end
  
  it "should return available locales" do
    I18n.available_locales.should =~ [:en]
  end
  
  it "should localize objects" do
    time = Time.at(0).utc
    date = Date.parse('1970-01-01')
    
    I18n.l(time).should == 'Thu, 01 Jan 1970 00:00:00 +0000'
    I18n.l(date).should == '1970-01-01'
    
    I18n.l(time, :format => :short).should == '01 Jan 00:00'
    I18n.l(time, :format => :full).should == '1st of January, 1970 00:00'
    
    I18n.l(-5000.5).should == '−5,000.5'
  end
  
  it "should translate by key and scope" do
    I18n.t('in.another.level').should               == 'Hierarchical'
    I18n.t(:level, :scope => 'in.another').should   == 'Hierarchical'
    I18n.t(:'another.level', :scope => 'in').should == 'Hierarchical'
  end
  
  it "should use pluralization and variables" do
    I18n.t(:users, :count => 0).should == '0 users'
    I18n.t(:users, :count => 1).should == '1 user'
    I18n.t(:users, :count => 5).should == '5 users'
  end
  
  it "should use another separator" do
    I18n.t('in/another/level', :separator => '/').should == 'Hierarchical'
  end
  
  it "should translate array" do
    I18n.t(['in.another.level', 'in.default']).should == ['Hierarchical',
                                                          'Default']
  end
  
  it "should use default value" do
    I18n.t(:missed, :default => 'Default').should == 'Default'
    I18n.t(:missed, :default => :default, :scope => :in).should == 'Default'
    I18n.t(:missed, :default => [:also_no, :'in.default']).should == 'Default'
  end
  
  it "should raise error on no translation" do
    lambda {
      I18n.backend.translate(:en, :missed)
    }.should raise_error(::I18n::MissingTranslationData)
    I18n.t(:missed).should == 'translation missing: en, missed'
  end
  
  it "should reload translations" do
    I18n.t(:other).should == 'translation missing: en, other'
    I18n.load_path << OTHER
    I18n.reload!
    I18n.t(:other).should == 'Other'
  end
  
end
