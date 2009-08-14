# encoding: utf-8
require File.join(File.dirname(__FILE__), 'spec_helper')

describe R18n::Translation do

  it "should return all available translations" do
    R18n::Translation.available(DIR).sort.should == ['en', 'no_LC', 'ru']
    R18n::Translation.available([TWO, DIR]).sort.should == [
        'en', 'fr', 'no_LC', 'ru']
  end

  it "should load translations" do
    translation = R18n::Translation.load('en', DIR)
    translation.one.should == 'One'
    translation['one'].should == 'One'
  end

  it "should find in subtranslations" do
    translation = R18n::Translation.load(['ru', 'en'], DIR)
    translation.one.should == 'Один'
    translation.two.should == 'Two'
  end

  it "should return nil if translation isn't found" do
    translation = R18n::Translation.load('en', DIR)
    translation.not.exists.should be_nil
    translation['not']['exists'].should be_nil
  end

  it "should can use params in translation" do
    translation = R18n::Translation.load('en', DIR)
    translation.params(-1, 2).should == 'Is −1 between −1 and 2?'
    translation['params', -1, 2].should == 'Is −1 between −1 and 2?'
  end

  it "should load use hierarchical translations" do
    translation = R18n::Translation.load(['ru', 'en'], DIR)
    translation.in.another.level.should == 'Иерархический'
    translation['in']['another']['level'].should == 'Иерархический'
    translation.only.english.should == 'Only in English'
  end
  
  it "should save path for translation" do
    translation = R18n::Translation.load('en', DIR)
    
    translation.in.another.level.path.should == 'in.another.level'
    
    translation.in.another.not.exists.path.should == 'in.another.not.exists'
    translation.in.another.not.exists.untranslated_path.should == 'not.exists'
    translation.in.another.not.exists.translated_path.should == 'in.another.'
    
    translation.not.untranslated_path.should == 'not'
    translation.not.translated_path.should == ''
  end

  it "should return string with locale info" do
    translation = R18n::Translation.load(['no_LC', 'en'], DIR)
    translation.one.locale.should == R18n::UnsupportedLocale.new('no_LC')
    translation.two.locale.should == R18n::Locale.load('en')
  end

  it "should load translations from several dirs" do
    translation = R18n::Translation.load(['no_LC', 'en'], [TWO, DIR])
    translation.in.two.should == 'Two'
    translation.in.another.level.should == 'Hierarchical'
  end

  it "should use extension translations" do
    R18n::Translation.extension_translations << EXT
    
    translation = R18n::Translation.load('en', DIR)
    translation.ext.should == 'Extension'
    translation.one.should == 'One'
  end

  it "shouldn't use extension without app translations with same locale" do
    R18n::Translation.extension_translations << EXT
    
    translation = R18n::Translation.load(['no_TR', 'en'], DIR)
    translation.ext.should == 'Extension'
  end

end
