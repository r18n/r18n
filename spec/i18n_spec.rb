require File.join(File.dirname(__FILE__), 'spec_helper')

describe R18n::I18n do
  DIR = Pathname(__FILE__).dirname + 'translations/general'

  it "should parse HTTP_ACCEPT_LANGUAGE" do
    R18n::I18n.parse_http_accept_language(nil).should == []
    R18n::I18n.parse_http_accept_language('').should == []
    R18n::I18n.parse_http_accept_language('ru,en;q=0.9').should == ['ru', 'en']
    R18n::I18n.parse_http_accept_language('ru;q=0.8,en;q=0.9').should == ['en', 'ru']
  end

  it "should has default locale" do
    R18n::I18n.default = 'ru'
    R18n::I18n.default.should == 'ru'
  end

  it "should load locales" do
    i18n = R18n::I18n.new('en', DIR)
    i18n.locales.should == [R18n::Locale.new('en')]
  
    i18n = R18n::I18n.new(['ru', 'no_LC'], DIR)
    i18n.locales.should == [R18n::Locale.new('ru'), 'no_LC']
  end

  it "should return translations dir" do
    i18n = R18n::I18n.new('en', DIR)
    i18n.translations_dir.should == DIR.expand_path.to_s
  end

  it "should load translations" do
    i18n = R18n::I18n.new(['ru', 'en'], DIR)
    i18n.one.should == 'Один'
    i18n.only.english.should == 'Only in English'
  end

  it "should load default translation" do
    R18n::I18n.default = 'en'
    
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
    i18n.translations.sort.should == ['English', 'no_LC', 'Русский']
  end
  
  it "should return first locale with locale file" do
    i18n = R18n::I18n.new(['no_LC', 'ru', 'en'], DIR)
    i18n.locale.should == R18n::Locale.new('ru')
  end

end
