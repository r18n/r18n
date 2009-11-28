# encoding: utf-8
require File.join(File.dirname(__FILE__), 'spec_helper')

describe R18n::I18n do
  after do
    R18n::I18n.default = 'en'
  end

  it "should parse HTTP_ACCEPT_LANGUAGE" do
    R18n::I18n.parse_http(nil).should == []
    R18n::I18n.parse_http('').should == []
    R18n::I18n.parse_http('ru,en;q=0.9').should == ['ru', 'en']
    R18n::I18n.parse_http('ru;q=0.8,en;q=0.9').should == ['en', 'ru']
  end

  it "should has default locale" do
    R18n::I18n.default = 'ru'
    R18n::I18n.default.should == 'ru'
  end

  it "should load locales" do
    i18n = R18n::I18n.new('en', DIR)
    i18n.locales.should == [R18n::Locale.load('en')]
  
    i18n = R18n::I18n.new(['ru', 'no-LC'], DIR)
    i18n.locales.should == [R18n::Locale.load('ru'),
                            R18n::UnsupportedLocale.new('no-LC'),
                            R18n::UnsupportedLocale.new('no'),
                            R18n::UnsupportedLocale.new('en')]
  end

  it "should return translations dir" do
    i18n = R18n::I18n.new('en', DIR)
    i18n.translation_dirs.expand_path.to_s.should == DIR.expand_path.to_s
  end

  it "should load translations" do
    i18n = R18n::I18n.new(['ru', 'en'], DIR)
    i18n.one.should == 'Один'
    i18n['one'].should == 'Один'
    i18n.only.english.should == 'Only in English'
  end

  it "should load default translation" do
    i18n = R18n::I18n.new('no-LC', DIR)
    i18n.one.should == 'ONE'
    i18n.two.should == 'Two'
  end

  it "should load sublocales for first locale" do
    R18n::I18n.default = 'no-TR'
    
    i18n = R18n::I18n.new('ru', DIR)
    i18n.one.should == 'Один'
    i18n.two.should == 'Two'
  end

  it "should return available translations" do
    i18n = R18n::I18n.new('en', DIR)
    i18n.translations.should == { 'no-lc' => 'no-lc', 'ru' => 'Русский',
                                  'en' => 'English' }
  end

  it "should return first locale with locale file" do
    i18n = R18n::I18n.new(['no-LC', 'ru', 'en'], DIR)
    i18n.locale.should == R18n::Locale.load('no-LC')
    i18n.locale.base.should == R18n::Locale.load('ru')
  end

  it "should localize objects" do
    i18n = R18n::I18n.new('ru')
    
    i18n.l(-123456789).should == '−123 456 789'
    i18n.l(-12345.67).should == '−12 345,67'
    
    time = Time.at(0).utc
    i18n.l(time, '%A').should == 'Четверг'
    i18n.l(time, :month).should == 'Январь'
    i18n.l(time, :standard).should == '01.01.1970 00:00'
    i18n.l(time, :full).should == ' 1 января 1970 00:00'
    
    i18n.l(Date.new(0)).should == '01.01.0000'
  end

end
