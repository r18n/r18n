require File.join(File.dirname(__FILE__), '..', 'spec_helper')
require File.join(File.dirname(__FILE__), '..', '..', 'locales', 'pl')

describe R18n::Locales::Pl do
  it "should use Polish pluralization" do
    pl = R18n::Locale.load 'pl'
    pl.pluralize(0).should == 0
    pl.pluralize(1).should == 1
    
    pl.pluralize(2).should   == 2
    pl.pluralize(4).should   == 2
    pl.pluralize(22).should  == 2
    pl.pluralize(102).should == 2
    
    pl.pluralize(5).should   == 'n'
    pl.pluralize(11).should  == 'n'
    pl.pluralize(12).should  == 'n'
    pl.pluralize(21).should  == 'n'
    pl.pluralize(57).should  == 'n'
    pl.pluralize(101).should == 'n'
    pl.pluralize(111).should == 'n'
    pl.pluralize(112).should == 'n'
  end
end
