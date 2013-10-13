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

  it "returns dir with translations" do
    @loader.dir.should == DIR.expand_path.to_s
  end

  it "equals to another YAML loader with same dir" do
    @loader.should == R18n::Loader::YAML.new(DIR)
    @loader.should_not == Class.new(R18n::Loader::YAML).new(DIR)
  end

  it "returns all available translations" do
    @loader.available.should =~ [R18n.locale('ru'),
                                 R18n.locale('en'),
                                 R18n.locale('nolocale')]
  end

  it "loads translation" do
    @loader.load(R18n.locale('ru')).should == {
      'one'   => 'Один',
      'in'    => { 'another' => { 'level' => 'Иерархический' } },
      'typed' => R18n::Typed.new('my', 'value')
    }
  end

  it "returns hash by dir" do
    @loader.hash.should == R18n::Loader::YAML.new(DIR).hash
  end

  it "loads in dir recursively" do
    loader = R18n::Loader::YAML.new(TRANSLATIONS)
    loader.available.should =~ [R18n.locale('ru'),
                                R18n.locale('en'),
                                R18n.locale('fr'),
                                R18n.locale('notransl'),
                                R18n.locale('nolocale')]

    translation = loader.load(R18n.locale('en'))
    translation['two'].should       == 'Two'
    translation['in']['two'].should == 'Two'
    translation['ext'].should       == 'Extension'
    translation['deep'].should      == 'Deep one'
  end

end
