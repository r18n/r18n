# encoding: utf-8
require File.join(File.dirname(__FILE__), 'spec_helper')

describe R18n::Translation do
  before :all do
    @en = R18n::Locale.load('en')
    @ru = R18n::Locale.load('ru')
  end

  it "should return all available translations" do
    R18n::Translation.available(DIR).should =~ ['en', 'no-lc', 'ru']
    R18n::Translation.available([TWO, DIR]).should =~ [
        'en', 'fr', 'no-lc', 'ru']
  end

  it "should load translations" do
    translation = R18n::Translation.load([@en], DIR)
    translation.one.should == 'One'
    translation['one'].should == 'One'
  end

  it "should find in subtranslations" do
    translation = R18n::Translation.load([@ru, @en], DIR)
    translation.one.should == 'Один'
    translation.two.should == 'Two'
  end

  it "should return nil if translation isn't found" do
    translation = R18n::Translation.load([@en], DIR)
    translation.not.exists.should be_nil
    translation['not']['exists'].should be_nil
  end

  it "should load use hierarchical translations" do
    translation = R18n::Translation.load([@ru, @en], DIR)
    translation.in.another.level.should == 'Иерархический'
    translation['in']['another']['level'].should == 'Иерархический'
    translation.only.english.should == 'Only in English'
  end
  
  it "should save path for translation" do
    translation = R18n::Translation.load([@en], DIR)
    
    translation.in.another.level.path.should == 'in.another.level'
    
    translation.in.another.not.exists.path.should == 'in.another.not.exists'
    translation.in.another.not.exists.untranslated_path.should == 'not.exists'
    translation.in.another.not.exists.translated_path.should == 'in.another.'
    
    translation.not.untranslated_path.should == 'not'
    translation.not.translated_path.should == ''
  end

  it "should return string with locale info" do
    translation = R18n::Translation.load([R18n::Locale.load('no-LC'), @en], DIR)
    translation.one.locale.should == R18n::UnsupportedLocale.new('no-LC')
    translation.two.locale.should == R18n::Locale.load('en')
  end

  it "should load translations from several dirs" do
    tr = R18n::Translation.load([R18n::Locale.load('no-LC'), @en], [TWO, DIR])
    tr.in.two.should == 'Two'
    tr.in.another.level.should == 'Hierarchical'
  end

  it "should use extension translations" do
    R18n::Translation.extension_translations << EXT
    
    translation = R18n::Translation.load([@en], DIR)
    translation.ext.should == 'Extension'
    translation.one.should == 'One'
  end

  it "shouldn't use extension without app translations with same locale" do
    R18n::Translation.extension_translations << EXT
    
    translation = R18n::Translation.load([R18n::Locale.load('no-TR'), @en], DIR)
    translation.ext.should == 'Extension'
  end
  
  it "should ignore case on loading" do
    translation = R18n::Translation.load([R18n::Locale.load('no-lc')], [DIR])
    translation.one.should == 'ONE'
    
    translation = R18n::Translation.load([R18n::Locale.load('no-LC')], [DIR])
    translation.one.should == 'ONE'
  end

end
