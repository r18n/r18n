# encoding: utf-8
require File.join(File.dirname(__FILE__), 'spec_helper')

describe R18n::Locale do
  before :all do
    @ru = R18n::Locale.load('ru')
    @en = R18n::Locale.load('en')
  end

  it "should return all available locales" do
    R18n::Locale.available.class.should == Array
    R18n::Locale.available.should_not be_empty
  end
  
  it "should check is locale exists" do
    R18n::Locale.exists?('ru').should be_true
    R18n::Locale.exists?('no-LC').should be_false
  end
  
  it "should set locale properties" do
    locale_class = Class.new(R18n::Locale) do
      set :one => 1
      set :two => 2
    end
    locale = locale_class.instance
    locale.one.should == 1
    locale.two.should == 2
  end

  it "should load locale" do
    @ru.class.should == R18n::Locales::Ru
    @ru.code.should  == 'ru'
    @ru.title.should == 'Русский'
  end
  
  it "should load locale by Symbol" do
    R18n::Locale.load(:ru).should == R18n::Locale.load('ru')
  end

  it "should be equal to another locale with same code" do
    @en.should_not == @ru
    @en.should == R18n::Locale.load('en')
  end

  it "should print human readable representation" do
    @ru.inspect.should == 'Locale ru (Русский)'
  end

  it "should return pluralization type by elements count" do
    @en.pluralize(0).should == 0
    @en.pluralize(1).should == 1
    @en.pluralize(5).should == 'n'
  end

  it "should use UnsupportedLocale if locale file isn't exists" do
    @en.should be_supported
    
    unsupported = R18n::Locale.load('no-LC')
    unsupported.should_not be_supported
    unsupported.should be_a(R18n::UnsupportedLocale)
    
    unsupported.code.should == 'no-LC'
    unsupported.title.should == 'no-LC'
    unsupported.ltr?.should be_true
    
    unsupported.pluralize(5).should == 'n'
    unsupported.inspect.should == 'Unsupported locale no-LC'
  end

  it "should format number in local traditions" do
    @en.localize(-123456789).should == "−123,456,789"
  end

  it "should format float in local traditions" do
    @en.localize(-12345.67).should == "−12,345.67"
  end

  it "should translate month, week days and am/pm names in strftime" do
    i18n = R18n::I18n.new 'ru'
    time = Time.at(0).utc
    
    @ru.localize(time, i18n, '%a %A').should == 'Чтв Четверг'
    @ru.localize(time, i18n, '%b %B').should == 'янв января'
    @ru.localize(time, i18n, '%H:%M%p').should == '00:00 утра'
  end
  
  it "should localize date for human" do
    i18n = R18n::I18n.new('ru')
    
    @ru.localize(Date.today + 2, i18n, :human).should == 'через 2 дня'
    @ru.localize(Date.today + 1, i18n, :human).should == 'завтра'
    @ru.localize(Date.today,     i18n, :human).should == 'сегодня'
    @ru.localize(Date.today - 1, i18n, :human).should == 'вчера'
    @ru.localize(Date.today - 3, i18n, :human).should == '3 дня назад'
    
    y2000 = Date.parse('2000-01-08')
    @ru.localize(y2000, i18n, :human, y2000 + 8  ).should == ' 8 января'
    @ru.localize(y2000, i18n, :human, y2000 - 365).should == ' 8 января 2000'
  end
  
  it "should localize times for human" do
    minute = 60
    hour   = 60 * minute
    day    = 24 * hour
    zero   = Time.at(0).utc
    params = [R18n::I18n.new('ru'), :human, zero]
    
    @ru.localize( zero + 7 * day,     *params).should == ' 8 января 00:00'
    @ru.localize( zero + 50 * hour,   *params).should == 'через 2 дня 02:00'
    @ru.localize( zero + 25 * hour,   *params).should == 'завтра 01:00'
    @ru.localize( zero + 70 * minute, *params).should == 'через 1 час'
    @ru.localize( zero + 38 * minute, *params).should == 'через 38 минут'
    @ru.localize( zero + 5,           *params).should == 'сейчас'
    @ru.localize( zero - 15,          *params).should == 'сейчас'
    @ru.localize( zero - minute,      *params).should == '1 минуту назад'
    @ru.localize( zero - 2 * hour,    *params).should == '2 часа назад'
    @ru.localize( zero - 13 * hour,   *params).should == 'вчера 11:00'
    @ru.localize( zero - 50 * hour,   *params).should == '3 дня назад 22:00'
    @ru.localize( zero - 9 * day,     *params).should == '23 декабря 1969 00:00'
  end
  
  it "should use standard formatter by default" do
    i18n = R18n::I18n.new('ru')
    @ru.localize(Time.at(0).utc, i18n).should == '01.01.1970 00:00'
  end
  
  it "shouldn't localize time without i18n object" do
    @ru.localize(Time.at(0)).should == Time.at(0).to_s
  end
  
  it "should raise error on unknown formatter" do
    lambda {
      @ru.localize(Time.at(0).utc, R18n::I18n.new('ru'), :unknown)
    }.should raise_error(ArgumentError, /formatter/)
  end

  it "should delete slashed from locale for security reasons" do
    locale = R18n::Locale.load('../spec/translations/general/en')
    locale.should be_a(R18n::UnsupportedLocale)
  end
  
  it "should ignore code case in locales" do
    upcase = R18n::Locale.load('RU')
    downcase = R18n::Locale.load('ru')
    upcase.should == downcase
    upcase.code.should == 'ru'
    downcase.code.should == 'ru'
    
    upcase = R18n::Locale.load('no-LC')
    downcase = R18n::Locale.load('no-lc')
    upcase.should == downcase
    upcase.code.should == 'no-LC'
    downcase.code.should == 'no-lc'
  end

end
