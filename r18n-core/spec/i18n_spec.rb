# encoding: utf-8
require File.join(File.dirname(__FILE__), 'spec_helper')

describe R18n::I18n do
  before do
    @extension_places = R18n.extension_places.clone
  end
  
  after do
    R18n::I18n.default = 'en'
    R18n.default_loader = R18n::Loader::YAML
    R18n.extension_places = @extension_places
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
                            R18n::Locale.load('en')]
  end

  it "should return translations loaders" do
    i18n = R18n::I18n.new('en', DIR)
    i18n.translation_places.should == [R18n::Loader::YAML.new(DIR)]
  end
  
  it "should load translations by loader" do
    loader = Class.new do
      def available; [R18n::Locale.load('en')]; end
      def load(locale); { 'custom' => 'Custom' }; end
    end
    R18n::I18n.new('en', loader.new).custom.should == 'Custom'
  end
  
  it "should pass parameters to default loader" do
    loader = Class.new do
      def initialize(param); @param = param; end
      def available; [R18n::Locale.load('en')]; end
      def load(locale); { 'custom' => @param }; end
    end
    R18n.default_loader = loader
    R18n::I18n.new('en', 'default').custom.should == 'default'
  end

  it "should load translations" do
    i18n = R18n::I18n.new(['ru', 'en'], DIR)
    i18n.one.should == 'Один'
    i18n[:one].should == 'Один'
    i18n['one'].should == 'Один'
    i18n.only.english.should == 'Only in English'
  end
  
  it "should load translations from several dirs" do
    i18n = R18n::I18n.new(['no-LC', 'en'], [TWO, DIR])
    i18n.in.two.should == 'Two'
    i18n.in.another.level.should == 'Hierarchical'
  end

  it "should use extension places" do
    R18n.extension_places << EXT
    
    i18n = R18n::I18n.new('en', DIR)
    i18n.ext.should == 'Extension'
    i18n.one.should == 'One'
  end

  it "shouldn't use extension without app translations with same locale" do
    R18n.extension_places << EXT
    
    i18n = R18n::I18n.new(['no-TR', 'en'], DIR)
    i18n.ext.should == 'Extension'
  end
  
  it "should ignore case on loading" do
    i18n = R18n::I18n.new('no-lc', [DIR])
    i18n.one.should == 'ONE'
    
    i18n = R18n::I18n.new('no-LC', [DIR])
    i18n.one.should == 'ONE'
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
    R18n::I18n.available_locales(DIR).should =~ [R18n::Locale.load('no-lc'),
                                                 R18n::Locale.load('ru'),
                                                 R18n::Locale.load('en')]
    i18n = R18n::I18n.new('en', DIR)
    i18n.available_locales.should =~ [R18n::Locale.load('no-lc'),
                                      R18n::Locale.load('ru'),
                                      R18n::Locale.load('en')]
  end
  
  it "should reload translations" do
    loader = Class.new do
      @@answer = 1
      def available; [R18n::Locale.load('en')]; end
      def load(locale); { 'one' => @@answer }; end
    end
    
    i18n = R18n::I18n.new('en', loader.new)
    i18n.one.should == 1
    
    loader.class_eval { @@answer = 2 }
    i18n.reload!
    i18n.one.should == 2
  end
  
  it "should return translations" do
    i18n = R18n::I18n.new('en', DIR)
    i18n.t.should be_a(R18n::Translation)
    i18n.t.one.should == 'One'
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
