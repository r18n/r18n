require File.join(File.dirname(__FILE__), "..", "spec_helper")
require File.join(File.dirname(__FILE__), "..", "..", "locales", "pl")

describe R18n::Locales::Pl do
  it "should use Polish pluralization" do
    ru = R18n::Locale.load 'pl'
    ru.pluralize(0).should == 0
    
    ru.pluralize(1).should == 1
    ru.pluralize(21).should == 'n'
    ru.pluralize(101).should == 'n'
    
    ru.pluralize(2).should == 2
    ru.pluralize(4).should == 2
    ru.pluralize(22).should == 2
    ru.pluralize(102).should == 2
    
    ru.pluralize(5).should == 'n'
    ru.pluralize(11).should == 'n'
    ru.pluralize(12).should == 'n'
    ru.pluralize(57).should == 'n'
    ru.pluralize(111).should == 'n'
    ru.pluralize(112).should == 'n'
  end
end
