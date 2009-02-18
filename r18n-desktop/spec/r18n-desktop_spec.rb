# encoding: utf-8
require File.join(File.dirname(__FILE__), 'spec_helper')

describe "r18n-desktop" do

  it "should return array of system locales" do
    locale = R18n::I18n.system_locale
    locale.class.should == String
    locale.should_not be_empty
  end

  it "should load I18n from system environment" do
    i18n = R18n.from_env('')
    i18n.class.should == R18n::I18n
    i18n.locale.should_not be_empty if String == i18n.locale.class
    
    i18n = R18n.from_env('', 'en')
    i18n.locale.should == R18n::Locale.load('en')
    
    R18n.get.should == i18n
  end

end
