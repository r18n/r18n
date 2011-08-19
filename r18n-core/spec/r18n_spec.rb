# encoding: utf-8
require File.expand_path('../spec_helper', __FILE__)

describe R18n do
  include R18n::Helpers
    
  after do
    R18n.default_loader = R18n::Loader::YAML
    R18n.reset
  end

  it "should store I18n" do
    i18n = R18n::I18n.new('en')
    R18n.set(i18n)
    R18n.get.should == i18n
    
    R18n.reset
    R18n.get.should be_nil
  end
  
  it "should set setter to I18n" do
    i18n = R18n::I18n.new('en')
    R18n.set(i18n)
    
    i18n = R18n::I18n.new('ru')
    R18n.set { i18n }
    
    R18n.get.should == i18n
  end
  
  it "shuld create I18n object by shortcut" do
    R18n.set('en', DIR)
    R18n.get.should be_a(R18n::I18n)
    R18n.get.locales.should == [R18n::Locale.load('en')]
    R18n.get.translation_places.should == [R18n::Loader::YAML.new(DIR)]
  end

  it "should store I18n via thread_set" do
    i18n = R18n::I18n.new('en')
    R18n.thread_set(i18n)
    R18n.get.should == i18n
    
    R18n.reset
    R18n.get.should be_nil
  end
  
  it "should reset I18n objects and cache" do
    R18n.cache[:a] = 1
    R18n.thread_set(R18n::I18n.new('en'))
    
    R18n.reset
    R18n.get.should be_nil
    R18n.cache.should be_empty
  end

  it "should thread_set setter to I18n" do
    i18n = R18n::I18n.new('en')
    R18n.thread_set(i18n)
    
    i18n = R18n::I18n.new('ru')
    R18n.thread_set { i18n }
    
    R18n.get.should == i18n
  end

  it "should store default loader class" do
    R18n.default_loader.should == R18n::Loader::YAML
    R18n.default_loader = Class
    R18n.default_loader.should == Class
  end
  
  it "should store cache" do
    R18n.cache.should be_a(Hash)
    
    R18n.cache = { 1 => 2 }
    R18n.cache.should == { 1 => 2 }
    
    R18n.cache.clear
    R18n.cache.should == {}
  end
  
  it "should convert Time to Date" do
      R18n::Utils.to_date(Time.now).should == Date.today
  end
  
  it "should map hash" do
    R18n::Utils.hash_map({'a' => 1, 'b' => 2}) { |k, v| [k + 'a', v + 1] }.
      should == { 'aa' => 2, 'ba' => 3 }
  end
  
  it "should merge hash recursively" do
    a = { :a => 1,
          :b => {:ba => 1, :bb => 1},
          :c => 1 }
    b = { :b => {:bb => 2, :bc => 2},
          :c => 2 }
    
    R18n::Utils.deep_merge!(a, b)
    a.should == { :a => 1,
                  :b => { :ba => 1, :bb => 2, :bc => 2 },
                  :c => 2 }
  end
  
  it "should have l and t methods" do
    R18n.set('en')
    t.yes.should == 'Yes'
    l(Time.at(0).utc).should == '01/01/1970 00:00'
  end
  
  it "should have helpers mixin" do
    obj = R18n::I18n.new 'en'
    R18n.set(obj)
    
    r18n.should == obj
    i18n.should == obj
    t.yes.should == 'Yes'
    l(Time.at(0).utc).should == '01/01/1970 00:00'
  end

end
