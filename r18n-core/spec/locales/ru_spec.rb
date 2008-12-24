require File.join(File.dirname(__FILE__), "..", "spec_helper")
require File.join(File.dirname(__FILE__), "..", "..", "locales", "ru")

describe R18n::Locales::Ru do
  it "should use Russian pluralization" do
    ru = R18n::Locale.load 'ru'
    ru.pluralize(0).should == 0
    
    ru.pluralize(1).should == 1
    ru.pluralize(21).should == 1
    ru.pluralize(101).should == 1
    
    ru.pluralize(2).should == 2
    ru.pluralize(4).should == 2
    ru.pluralize(22).should == 2
    ru.pluralize(102).should == 2
    
    ru.pluralize(5).should == 'n'
    ru.pluralize(11).should == 'n'
    ru.pluralize(12).should == 'n'
    ru.pluralize(57).should == 'n'
    ru.pluralize(111).should == 'n'
  end
end
