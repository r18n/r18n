# encoding: utf-8
require File.expand_path('../../spec_helper', __FILE__)

describe R18n::Locales::It do
  it "should format Italian date" do
    italian = R18n::I18n.new('it')
    italian.l(Date.parse('2009-07-01'), :full).should == "1º luglio 2009"
    italian.l(Date.parse('2009-07-02'), :full).should == ' 2 luglio 2009'
    italian.l(Date.parse('2009-07-12'), :full).should == '12 luglio 2009'
  end
end
