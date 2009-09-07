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
  
    i18n = R18n::I18n.new(['ru', 'no_LC'], DIR)
    i18n.locales.should == [R18n::Locale.load('ru'),
                            R18n::UnsupportedLocale.new('no_LC')]
  end
  
  it "should return translation locales" do
    i18n = R18n::I18n.new(['no_LC', 'ru'], DIR)
    i18n.translation_locales.should == [
        R18n::Locale.load('no_LC'), R18n::Locale.load('no'), 
        R18n::Locale.load('ru'), R18n::Locale.load('en')]
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
    i18n = R18n::I18n.new('no_LC', DIR)
    i18n.one.should == 'ONE'
    i18n.two.should == 'Two'
  end

  it "should load sublocales for first locale" do
    R18n::I18n.default = 'no_TR'
    
    i18n = R18n::I18n.new('ru', DIR)
    i18n.one.should == 'Один'
    i18n.two.should == 'Two'
  end

  it "should return available translations" do
    i18n = R18n::I18n.new('en', DIR)
    i18n.translations.should == {
      'no_LC' => 'no_LC', 'ru' => 'Русский', 'en' => 'English'}
  end

  it "should return first locale with locale file" do
    i18n = R18n::I18n.new(['no_LC', 'ru', 'en'], DIR)
    i18n.locale.should == R18n::Locale.load('ru')
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
  
  it "should localize date for human" do
    i18n = R18n::I18n.new('ru')
    
    i18n.l(Date.today + 2, :human).should == 'через 2 дня'
    i18n.l(Date.today + 1, :human).should == 'завтра'
    i18n.l(Date.today,     :human).should == 'сегодня'
    i18n.l(Date.today - 1, :human).should == 'вчера'
    i18n.l(Date.today - 3, :human).should == '3 дня назад'
    
    y2000 = Date.parse('2000-01-08')
    i18n.l(y2000, :human, Date.parse('2000-01-01')).should == ' 8 января'
    i18n.l(y2000, :human, Date.parse('1999-01-01')).should == ' 8 января 2000'
  end
  
  it "should localize times for human" do
    i18n = R18n::I18n.new('ru')
    minute = 60
    hour   = 60 * minute
    day    = 24 * hour
    zero   = Time.at(0).utc
    
    i18n.l( zero + 7 * day,     :human, zero).should == ' 8 января 00:00'
    i18n.l( zero + 50 * hour,   :human, zero).should == 'через 2 дня 02:00'
    i18n.l( zero + 25 * hour,   :human, zero).should == 'завтра 01:00'
    i18n.l( zero + 70 * minute, :human, zero).should == 'через 1 час'
    i18n.l( zero + 38 * minute, :human, zero).should == 'через 38 минут'
    i18n.l( zero + 5,           :human, zero).should == 'сейчас'
    i18n.l( zero - 15,          :human, zero).should == 'сейчас'
    i18n.l( zero - minute,      :human, zero).should == '1 минуту назад'
    i18n.l( zero - 2 * hour,    :human, zero).should == '2 часа назад'
    i18n.l( zero - 13 * hour,   :human, zero).should == 'вчера 11:00'
    i18n.l( zero - 50 * hour,   :human, zero).should == '3 дня назад 22:00'
    i18n.l( zero - 9 * day,     :human, zero).should == '23 декабря 1969 00:00'
  end
  
  it "should use standard formatter by default" do
    R18n::I18n.new('ru').l(Time.at(0).utc).should == '01.01.1970 00:00'
  end
  
  it "should raise error on unknown formatter" do
    lambda {
      R18n::I18n.new('ru').l(Time.at(0).utc, :unknown)
    }.should raise_error(ArgumentError, /formatter/)
  end

end
