# encoding: utf-8
require File.expand_path('../spec_helper', __FILE__)

describe R18n::Loader::YAML do
  before :all do
    R18n::Filters.add('my', :my) { |i| i }
  end

  after :all do
    R18n::Filters.delete(:my)
  end

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
    @loader.available.should =~ [R18n.locale('ru'),
                                 R18n.locale('en'),
                                 R18n.locale('no-lc')]
  end

  it "should load translation" do
    @loader.load(R18n.locale('ru')).should == {
      'one' => 'Один', 'in' => {'another' => {'level' => 'Иерархический'}},
      'typed' => R18n::Typed.new('my', 'value') }
  end

  it "should return hash by dir" do
    @loader.hash.should == R18n::Loader::YAML.new(DIR).hash
  end

  it "should load in dir recursively" do
    loader = R18n::Loader::YAML.new(TRANSLATIONS)
    loader.available.should =~ [R18n.locale('ru'),
                                R18n.locale('en'),
                                R18n.locale('fr'),
                                R18n.locale('no-tr'),
                                R18n.locale('no-lc')]

    translation = loader.load(R18n.locale('en'))
    translation['two'].should       == 'Two'
    translation['in']['two'].should == 'Two'
    translation['ext'].should       == 'Extension'
    translation['deep'].should      == 'Deep one'
  end

end
