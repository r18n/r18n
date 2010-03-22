require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe R18n::Locales::Ru do
  it "should use Thai calendar" do
    th = R18n::I18n.new('th')
    th.l(Time.at(0).utc, '%Y %y').should ==  '2513 13'
    th.l(Time.at(0).utc).should == '01/01/2513 00:00'
  end
end
