require File.join(File.dirname(__FILE__), 'spec_helper')

describe R18n do

  it "should set I18n for current thread" do
    i18n = R18n::I18n.new('en', '')
    R18n.set(i18n)
    R18n.get.should == i18n
  end

  it "should load I18n from system environment" do
    i18n = R18n.from_env('')
    i18n.class.should == R18n::I18n
    if R18n::Locale != i18n.locales.first
      i18n.locales.first.size.should > 0
    end
    
    i18n = R18n.from_env('', 'en')
    i18n.locales.first.should == R18n::Locale.new('en')
    
    R18n.get.should == i18n
  end

  it "should load from HTTP_ACCEPT_LANGUAGE" do
    i18n = R18n.from_http('', 'ru,en;q=0.9')
    i18n.class.should == R18n::I18n
    i18n.locales.should == [R18n::Locale.new('ru'), R18n::Locale.new('en')]
    
    i18n = R18n.from_http('', 'ru', 'en')
    i18n.locales.should == [R18n::Locale.new('en'), R18n::Locale.new('ru')]
    
    R18n.get.should == i18n
  end

end
