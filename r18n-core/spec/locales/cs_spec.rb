require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe R18n::Locales::Cs do
  it "should use Czech pluralization" do
    cs = R18n::Locale.load('cs')
    cs.pluralize(0).should == 0
    cs.pluralize(1).should == 1
    
    cs.pluralize(2).should == 2
    cs.pluralize(3).should == 2
    cs.pluralize(4).should == 2
    
    cs.pluralize(5).should   == 'n'
    cs.pluralize(21).should  == 'n'
    cs.pluralize(11).should  == 'n'
    cs.pluralize(12).should  == 'n'
    cs.pluralize(22).should  == 'n'
    cs.pluralize(57).should  == 'n'
    cs.pluralize(101).should == 'n'
    cs.pluralize(102).should == 'n'
    cs.pluralize(111).should == 'n'
  end
end
