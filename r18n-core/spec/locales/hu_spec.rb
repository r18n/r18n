# encoding: utf-8
require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe R18n::Locales::Hu do
  it "should use Hungarian digits groups" do
    hu = R18n::I18n.new('hu')
    hu.l(1000).should   ==  '1000'
    hu.l(10000).should  ==  '10 000'
    hu.l(-10000).should == '−10 000'
    hu.l(100000).should ==  '100 000'
  end
    
  it "should use Hungarian time format" do
    hu = R18n::I18n.new('hu')
    hu.l(Time.at(0).utc).should        == '1970. 01. 01., 00:00'
    hu.l(Time.at(0).utc, :full).should == '1970. január  1., 00:00'
  end
end
