# encoding: utf-8
require File.join(File.dirname(__FILE__), 'spec_helper')

describe R18n do

  it "should set I18n for current thread" do
    i18n = R18n::I18n.new('en', '')
    R18n.set(i18n)
    R18n.get.should == i18n
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
