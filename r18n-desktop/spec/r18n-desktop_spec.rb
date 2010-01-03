# encoding: utf-8
require File.join(File.dirname(__FILE__), 'spec_helper')

describe "r18n-desktop" do
  include R18n::Helpers

  it "should return array of system locales" do
    locale = R18n::I18n.system_locale
    locale.class.should == String
    locale.should_not be_empty
  end

  it "should load I18n from system environment" do
    R18n.from_env('')
    r18n.class.should == R18n::I18n
    r18n.locale.should_not be_empty if String == r18n.locale.class
    
    R18n.from_env('', 'en')
    r18n.locale.should == R18n::Locale.load('en')
    
    R18n.get.should == r18n
  end
  
  it "should add helpers" do
    
  end

end
