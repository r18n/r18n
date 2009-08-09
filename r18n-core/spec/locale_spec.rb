# encoding: utf-8
require File.join(File.dirname(__FILE__), "spec_helper")

describe R18n::Locale do

  it "should check is locale exists" do
    R18n::Locale.exists?('ru').should be_true
    R18n::Locale.exists?('no_LC').should be_false
  end

  it "should load locale" do
    locale = R18n::Locale.load('ru')
    locale['code'].should == 'ru'
    locale['title'].should == 'Русский'
  end
  
  it "should use locale's class" do
    ru = R18n::Locale.load('ru')
    ru.class.should == R18n::Locales::Ru
    
    en = R18n::Locale.load('en')
    en.class.should == R18n::Locale
  end

  it "should include locale by +include+ option" do
    en_US = R18n::Locale.load('en_US')
    en = R18n::Locale.load('en')
    en_US['title'].should == 'English (US)'
    en['title'].should == 'English'
    en_US['week'].should == en['week']
  end

  it "should be equal to another locale with same code" do
    ru = R18n::Locale.load('ru')
    en = R18n::Locale.load('en')
    another_en = R18n::Locale.load('en')
    en.should_not == ru
    en.should == another_en
  end

  it "should print human readable representation" do
    R18n::Locale.load('ru').inspect.should == 'Locale ru (Русский)'
  end

  it "should return all available locales" do
    R18n::Locale.available.class.should == Array
    R18n::Locale.available.should_not be_empty
  end

  it "should return pluralization type by elements count" do
    locale = R18n::Locale.load('en')
    locale.pluralize(0).should == 0
    locale.pluralize(1).should == 1
    locale.pluralize(5).should == 'n'
  end

  it "should use UnsupportedLocale if locale file isn't exists" do
    supported = R18n::Locale.load('en')
    supported.should be_supported
    
    unsupported = R18n::Locale.load('no_LC')
    unsupported.should_not be_supported
    unsupported.should be_a(R18n::UnsupportedLocale)
    unsupported['code'].should == 'no_LC'
    unsupported['title'].should be_empty
    unsupported['direction'].should == 'ltr'
    unsupported.pluralize(5).should == 'n'
  end

  it "should format number in local traditions" do
    locale = R18n::Locale.load('en')
    locale.format_integer(-123456789).should == "−123,456,789"
  end

  it "should format float in local traditions" do
    locale = R18n::Locale.load('en')
    locale.format_float(-12345.67).should == "−12,345.67"
  end

  it "should translate month, week days and am/pm names in strftime" do
    locale =  R18n::Locale.load('ru')
    time = Time.at(0).utc
    
    locale.strftime(time, '%a %A').should == 'Чтв Четверг'
    locale.strftime(time, '%b %B').should == 'янв января'
    locale.strftime(time, '%H:%M%p').should == '00:00 утра'
  end

  it "should delete slashed from locale for security reasons" do
    locale = R18n::Locale.load('../spec/translations/general/en')
    locale.should be_a(R18n::UnsupportedLocale)
  end

end
