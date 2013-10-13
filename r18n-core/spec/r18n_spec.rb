# encoding: utf-8
require File.expand_path('../spec_helper', __FILE__)

describe R18n do
  include R18n::Helpers

  after do
    R18n.default_loader = R18n::Loader::YAML
    R18n.default_places = nil
    R18n.reset!
  end

  it "stores I18n" do
    i18n = R18n::I18n.new('en')
    R18n.set(i18n)
    R18n.get.should == i18n

    R18n.reset!
    R18n.get.should be_nil
  end

  it "sets setter to I18n" do
    i18n = R18n::I18n.new('en')
    R18n.set(i18n)

    i18n = R18n::I18n.new('ru')
    R18n.set { i18n }

    R18n.get.should == i18n
  end

  it "creates I18n object by shortcut" do
    R18n.set('en', DIR)
    R18n.get.should be_a(R18n::I18n)
    R18n.get.locales.should == [R18n.locale('en')]
    R18n.get.translation_places.should == [R18n::Loader::YAML.new(DIR)]
  end

  it "allows to return I18n arguments in setter block" do
    R18n.set { 'en' }
    R18n.get.locales.should == [R18n.locale('en')]
  end

  it "clears cache" do
    R18n.cache[:a] = 1
    R18n.clear_cache!
    R18n.cache.should be_empty
  end

  it "resets I18n objects and cache" do
    R18n.cache[:a] = 1
    R18n.set('en')
    R18n.thread_set('en')

    R18n.reset!
    R18n.get.should be_nil
    R18n.cache.should be_empty
  end

  it "stores I18n via thread_set" do
    i18n = R18n::I18n.new('en')
    R18n.thread_set(i18n)
    R18n.get.should == i18n

    i18n = R18n::I18n.new('ru')
    R18n.thread_set { i18n }
    R18n.get.should == i18n
  end

  it "allows to temporary change locale" do
    R18n.default_places = DIR
    R18n.change('en').locales.should == [R18n.locale('en')]
    R18n.change('en').should have(1).translation_places
    R18n.change('en').translation_places.first.dir.should == DIR.to_s
  end

  it "allows to temporary change current locales" do
    R18n.set('ru')
    R18n.change('en').locales.should == [R18n.locale('en'), R18n.locale('ru')]
    R18n.change('en').translation_places.should == R18n.get.translation_places
    R18n.get.locale.code.should.should == 'ru'
  end

  it "allows to get Locale to temporary change" do
    R18n.set('ru')
    R18n.change(R18n.locale('en')).locale.code.should == 'en'
  end

  it "has shortcut to load locale" do
    R18n.locale('ru').should == R18n::Locale.load('ru')
  end

  it "stores default loader class" do
    R18n.default_loader.should == R18n::Loader::YAML
    R18n.default_loader = Class
    R18n.default_loader.should == Class
  end

  it "stores cache" do
    R18n.cache.should be_a(Hash)

    R18n.cache = { 1 => 2 }
    R18n.cache.should == { 1 => 2 }

    R18n.clear_cache!
    R18n.cache.should == { }
  end

  it "converts Time to Date" do
    R18n::Utils.to_date(Time.now).should == Date.today
  end

  it "maps hash" do
    R18n::Utils.hash_map({'a' => 1, 'b' => 2}) { |k, v| [k + 'a', v + 1] }.
      should == { 'aa' => 2, 'ba' => 3 }
  end

  it "merges hash recursively" do
    a = { :a => 1, :b => {:ba => 1, :bb => 1}, :c => 1 }
    b = {          :b => {:bb => 2, :bc => 2}, :c => 2 }

    R18n::Utils.deep_merge!(a, b)
    a.should == { :a => 1, :b => { :ba => 1, :bb => 2, :bc => 2 }, :c => 2 }
  end

  it "has l and t methods" do
    R18n.set('en')
    t.yes.should == 'Yes'
    l(Time.at(0).utc).should == '01/01/1970 00:00'
  end

  it "has helpers mixin" do
    obj = R18n::I18n.new('en')
    R18n.set(obj)

    r18n.should  == obj
    i18n.should  == obj
    t.yes.should == 'Yes'
    l(Time.at(0).utc).should == '01/01/1970 00:00'
  end

  it "returns available translations" do
    R18n.available_locales(DIR).should =~ [R18n.locale('nolocale'),
                                           R18n.locale('ru'),
                                           R18n.locale('en')]
  end

  it "uses default places" do
    R18n.default_places = DIR
    R18n.set('en')
    t.one.should == 'One'
    R18n.available_locales.should =~ [R18n.locale('ru'),
                                      R18n.locale('en'),
                                      R18n.locale('nolocale')]
  end

  it "sets default places by block" do
    R18n.default_places { DIR }
    R18n.default_places.should == DIR
  end

  it "allows to ignore default places" do
    R18n.default_places = DIR
    i18n = R18n::I18n.new('en', nil)
    i18n.one.should_not be_translated
  end

end
