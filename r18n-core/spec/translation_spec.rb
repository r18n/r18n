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
    translation.params(1, 2).should == 'Is 1 between 1 and 2?'
    translation['params', 1, 2].should == 'Is 1 between 1 and 2?'
  end

  it "should load use hierarchical translations" do
    translation = R18n::Translation.load(['ru', 'en'], DIR)
    translation.in.another.should == 'Иерархический'
    translation['in']['another'].should == 'Иерархический'
    translation.only.english.should == 'Only in English'
  end

  it "should return string with locale info" do
    translation = R18n::Translation.load(['no_LC', 'en'], DIR)
    translation.one.locale.should == 'no_LC'
    translation.two.locale.should == R18n::Locale.load('en')
  end

  it "should load translations from several dirs" do
    translation = R18n::Translation.load(['no_LC', 'en'], [TWO, DIR])
    translation.in.two.should == 'Two'
    translation.in.another.should == 'Hierarchical'
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

  it "should call proc in translation" do
    translation = R18n::Translation.load('en', DIR)
    translation.sum(2, 3).should == 5
  end
  
  it "shouldn't call proc if it isn't secure" do
    translation = R18n::Translation.load('en', DIR)
    R18n::Translation.call_proc = false
    R18n::Translation.call_proc.should be_false
    translation.sum(2, 3).should == '|x, y| x + y'
    R18n::Translation.call_proc = true
  end

  it "should pluralize translation" do
    translation = R18n::Translation.load('en', DIR)
    translation.comments(0, 'article').should == 'no comments for article'
    translation.comments(1, 'article').should == 'one comment for article'
    translation.comments(5, 'article').should == '5 comments for article'
    
    translation.files(0).should == '0 files'
  end

  it "should return unknown YAML type" do
    translation = R18n::Translation.load('en', DIR)
    
    translation.my_type.class.should == YAML::PrivateType
    translation.my_type.type_id.should == 'special_type'
    translation.my_type.value.should == {'attr' => 'value'}
  end

  it "should pluralize translation without locale" do
    translation = R18n::Translation.load('no_LC', DIR)
    translation.entries(1).should == 'ONE'
    translation.entries(5).should == 'N'
  end

end
