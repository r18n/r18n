require File.join(File.dirname(__FILE__), "spec_helper")

describe R18n::Locale do

  it "should check is locale exists" do
    R18n::Locale.exists?('ru').should be_true
    R18n::Locale.exists?('no_LC').should be_false
  end

  it "should load locale" do
    locale = R18n::Locale.new 'ru'
    locale['code'].should == 'ru'
    locale['title'].should == 'Русский'
  end

  it "should include locale by +include+ option" do
    en_US = R18n::Locale.new 'en_US'
    en = R18n::Locale.new 'en'
    en_US['title'].should == 'English (US)'
    en['title'].should == 'English'
    en_US['week'].should == en['week']
  end

  it "should raise error if locale isn't exists" do
    lambda {
      R18n::Locale.new 'no_LC'
    }.should raise_error
  end

  it "should be equal to another locale with same code" do
    ru = R18n::Locale.new 'ru'
    en = R18n::Locale.new 'en'
    another_en = R18n::Locale.new 'en'
    en.should_not == ru
    en.should == another_en
  end

  it "should print human readable representation" do
    R18n::Locale.new('ru').inspect.should == 'Locale ru (Русский)'
  end

  it "should return all available locales" do
    R18n::Locale.available.sort.should == ['en', 'en_US', 'ru']
  end

  it "should return pluralization type by elements count" do
    locale = R18n::Locale.new 'en'
    locale.pluralize(0).should == 0
    locale.pluralize(1).should == 1
    locale.pluralize(5).should == 'n'
  end

  it "should has default pluralization to translation without locale file" do
    R18n::Locale.default_pluralize(0).should == 0
    R18n::Locale.default_pluralize(1).should == 1
    R18n::Locale.default_pluralize(5).should == 'n'
  end

end
