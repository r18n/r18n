# encoding: utf-8
require File.join(File.dirname(__FILE__), 'spec_helper')

describe R18n::Loader::YAML do
  before do
    @loader = R18n::Loader::YAML.new(DIR)
  end
  
  it "should return dir with translations" do
    @loader.dir.should == DIR.expand_path.to_s
  end
  
  it "should be equal to another YAML loader with same dir" do
    @loader.should == R18n::Loader::YAML.new(DIR)
    @loader.should_not == Class.new(R18n::Loader::YAML).new(DIR)
  end
  
  it "should return all available translations" do
    @loader.available.should =~ [R18n::Locale.load('ru'),
                                 R18n::Locale.load('en'),
                                 R18n::Locale.load('no-lc')]
  end
  
  it "should load translation" do
    @loader.load(R18n::Locale.load('ru')).should == {
      'one' => 'Один', 'in' => {'another' => {'level' => 'Иерархический'}},
      'typed' => R18n::Typed.new('my', 'value') }
  end
  
  it "should return hash by dir" do
    @loader.hash.should == R18n::Loader::YAML.new(DIR).hash
  end
  
  it "should load in dir recursively" do
    loader = R18n::Loader::YAML.new(TRANSLATIONS)
    loader.available.should =~ [R18n::Locale.load('ru'),
                                R18n::Locale.load('en'),
                                R18n::Locale.load('fr'),
                                R18n::Locale.load('no-tr'),
                                R18n::Locale.load('no-lc')]
    
    translation = loader.load(R18n::Locale.load('en'))
    translation['one'].should       == 'One'
    translation['in']['two'].should == 'Two'
    translation['ext'].should       == 'Extension'
  end
  
end
