# encoding: utf-8
require File.join(File.dirname(__FILE__), 'spec_helper')

describe R18n::Translation do
  
  it "should return nil if translation isn't found" do
    i18n = R18n::I18n.new('e', DIR)
    i18n.not.exists.should be_nil
    i18n['not']['exists'].should be_nil
  end

  it "should load use hierarchical translations" do
    i18n = R18n::I18n.new(['ru', 'en'], DIR)
    i18n.in.another.level.should == 'Иерархический'
    i18n[:in][:another][:level].should == 'Иерархический'
    i18n['in']['another']['level'].should == 'Иерархический'
    i18n.only.english.should == 'Only in English'
  end
  
  it "should save path for translation" do
    i18n = R18n::I18n.new('en', DIR)
    
    i18n.in.another.level.path.should == 'in.another.level'
    
    i18n.in.another.not.exists.path.should == 'in.another.not.exists'
    i18n.in.another.not.exists.untranslated_path.should == 'not.exists'
    i18n.in.another.not.exists.translated_path.should == 'in.another.'
    
    i18n.not.untranslated_path.should == 'not'
    i18n.not.translated_path.should == ''
  end

  it "should return string with locale info" do
    i18n = R18n::I18n.new(['no-LC', 'en'], DIR)
    i18n.one.locale.should == R18n::UnsupportedLocale.new('no-LC')
    i18n.two.locale.should == R18n::Locale.load('en')
  end

end
