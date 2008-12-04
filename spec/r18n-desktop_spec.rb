require File.join(File.dirname(__FILE__), 'spec_helper')

describe "r18n-desktop" do

  it "should return array of system locales" do
    locales = R18n::I18n.system_locale
    locales.class.should == String
    locales.should_not be_empty
  end

  it "should load I18n from system environment" do
    i18n = R18n.from_env('')
    i18n.class.should == R18n::I18n
    if R18n::Locale != i18n.locale.class
      i18n.locale.should_not be_empty
    end
    
    i18n = R18n.from_env('', 'en')
    i18n.locale.should == R18n::Locale.new('en')
    
    R18n.get.should == i18n
  end

end
