# encoding: utf-8
require File.expand_path('../spec_helper', __FILE__)
require 'bigdecimal'

describe R18n::Locale do
  before :all do
    @ru = R18n.locale('ru')
    @en = R18n.locale('en')
  end

  it "should return all available locales" do
    R18n::Locale.available.class.should == Array
    R18n::Locale.available.should_not be_empty
  end

  it "should check is locale exists" do
    R18n::Locale.exists?('ru').should be_true
    R18n::Locale.exists?('nolocale').should be_false
  end

  it "should set locale properties" do
    locale_class = Class.new(R18n::Locale) do
      set :one => 1
      set :two => 2
    end
    locale = locale_class.new
    locale.one.should == 1
    locale.two.should == 2
  end

  it "should load locale" do
    @ru.class.should == R18n::Locales::Ru
    @ru.code.should  == 'ru'
    @ru.title.should == 'Русский'
  end

  it "should load locale by Symbol" do
    R18n.locale(:ru).should == R18n.locale('ru')
  end

  it "should be equal to another locale with same code" do
    @en.should_not == @ru
    @en.should == R18n.locale('en')
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

    unsupported = R18n.locale('nolocale-DL')
    unsupported.should_not be_supported
    unsupported.should be_a(R18n::UnsupportedLocale)

    unsupported.code.downcase.should  == 'nolocale-dl'
    unsupported.title.downcase.should == 'nolocale-dl'
    unsupported.ltr?.should be_true

    unsupported.pluralize(5).should == 'n'
    unsupported.inspect.downcase.should == 'unsupported locale nolocale-dl'
  end

  it "should format number in local traditions" do
    @en.localize(-123456789).should == "−123,456,789"
  end

  it "should format float in local traditions" do
    @en.localize(-12345.67).should == "−12,345.67"
    @en.localize(BigDecimal.new("-12345.67")).should == "−12,345.67"
  end

  it "should translate month, week days and am/pm names in strftime" do
    i18n = R18n::I18n.new('ru')
    time = Time.at(0).utc

    @ru.localize(time, '%a %A').should == 'Чтв Четверг'
    @ru.localize(time, '%b %B').should == 'янв января'
    @ru.localize(time, '%H:%M%p').should == '00:00 утра'
  end

  it "should generate locale code by locale class name" do
    R18n.locale('ru').code.should    == 'ru'
    R18n.locale('zh-CN').code.should == 'zh-CN'
  end

  it "should localize date for human" do
    i18n = R18n::I18n.new('en')

    @en.localize(Date.today + 2, :human, i18n).should == 'after 2 days'
    @en.localize(Date.today + 1, :human, i18n).should == 'tomorrow'
    @en.localize(Date.today,     :human, i18n).should == 'today'
    @en.localize(Date.today - 1, :human, i18n).should == 'yesterday'
    @en.localize(Date.today - 3, :human, i18n).should == '3 days ago'

    y2k = Date.parse('2000-01-08')
    @en.localize(y2k, :human, i18n, y2k + 8  ).should == '8th of January'
    @en.localize(y2k, :human, i18n, y2k - 365).should == '8th of January, 2000'
  end

  it "should localize times for human" do
    minute = 60
    hour   = 60 * minute
    day    = 24 * hour
    zero   = Time.at(0).utc
    p = [:human, R18n::I18n.new('en'), zero]

    @en.localize( zero + 7  * day,    *p).should == '8th of January 00:00'
    @en.localize( zero + 50 * hour,   *p).should == 'after 2 days 02:00'
    @en.localize( zero + 25 * hour,   *p).should == 'tomorrow 01:00'
    @en.localize( zero + 70 * minute, *p).should == 'after 1 hour'
    @en.localize( zero + hour,        *p).should == 'after 1 hour'
    @en.localize( zero + 38 * minute, *p).should == 'after 38 minutes'
    @en.localize( zero + 5,           *p).should == 'now'
    @en.localize( zero - 15,          *p).should == 'now'
    @en.localize( zero - minute,      *p).should == '1 minute ago'
    @en.localize( zero - hour + 59,   *p).should == '59 minutes ago'
    @en.localize( zero - 2  * hour,   *p).should == '2 hours ago'
    @en.localize( zero - 13 * hour,   *p).should == 'yesterday 11:00'
    @en.localize( zero - 50 * hour,   *p).should == '3 days ago 22:00'

    @en.localize( zero - 9  * day,  *p).should == '23rd of December, 1969 00:00'
    @en.localize( zero - 365 * day, *p).should == '1st of January, 1969 00:00'
  end

  it "should use standard formatter by default" do
    @ru.localize(Time.at(0).utc).should == '01.01.1970 00:00'
  end

  it "shouldn't localize time without i18n object" do
    @ru.localize(Time.at(0)).should_not == Time.at(0).to_s
    @ru.localize(Time.at(0), :full).should_not == Time.at(0).to_s

    @ru.localize(Time.at(0), :human).should == Time.at(0).to_s
  end

  it "should raise error on unknown formatter" do
    lambda {
      @ru.localize(Time.at(0).utc, R18n::I18n.new('ru'), :unknown)
    }.should raise_error(ArgumentError, /formatter/)
  end

  it "should delete slashed from locale for security reasons" do
    locale = R18n.locale('../spec/translations/general/en')
    locale.should be_a(R18n::UnsupportedLocale)
  end

  it "should ignore code case in locales" do
    upcase   = R18n.locale('RU')
    downcase = R18n.locale('ru')
    upcase.should == downcase
    upcase.code.should   == 'ru'
    downcase.code.should == 'ru'

    upcase   = R18n.locale('nolocale')
    downcase = R18n.locale('nolocale')
    upcase.should == downcase
    upcase.code.should   == 'nolocale'
    downcase.code.should == 'nolocale'
  end

  it "should load locale with underscore" do
    R18n.locale('nolocale-DL').code.should == 'nolocale-dl'
  end

end
