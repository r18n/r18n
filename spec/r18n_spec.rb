require File.join(File.dirname(__FILE__), 'spec_helper')

describe R18n do

  it "should set I18n for current thread" do
    i18n = R18n::I18n.new('en', '')
    R18n.set(i18n)
    R18n.get.should == i18n
  end

end
