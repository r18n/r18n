# encoding: utf-8
require File.join(File.dirname(__FILE__), 'spec_helper')

describe R18n do
  after do
    R18n.default_loader = R18n::Loader::YAML
  end

  it "should set I18n for current thread" do
    i18n = R18n::I18n.new('en', '')
    R18n.set(i18n)
    R18n.get.should == i18n
  end
  
  it "should save default loader class" do
    R18n.default_loader.should == R18n::Loader::YAML
    R18n.default_loader = Class
    R18n.default_loader.should == Class
  end

  it "should merge hash recursively" do
    a = { :a => 1,
          :b => {:ba => 1, :bb => 1},
          :c => 1 }
    b = { :b => {:bb => 2, :bc => 2},
          :c => 2 }
    
    R18n::Utils.deep_merge! a, b
    a.should == { :a => 1,
                  :b => { :ba => 1, :bb => 2, :bc => 2 },
                  :c => 2 }
  end
  
  it "should convert Time to Date" do
      R18n::Utils.to_date(Time.now).should == Date.today
  end

end
