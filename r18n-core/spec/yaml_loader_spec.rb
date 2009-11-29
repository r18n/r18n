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
    @loader.available.should == [R18n::Locale.load('ru'),
                                 R18n::Locale.load('en'),
                                 R18n::Locale.load('no-lc')]
  end
  
  it "should load translation" do
    @loader.load(R18n::Locale.load('ru')).should == {
      'one' => 'Один', 'in' => {'another' => {'level' => 'Иерархический'}} }
  end
  
end
