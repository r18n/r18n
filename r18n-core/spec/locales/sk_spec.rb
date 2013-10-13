require File.expand_path('../../spec_helper', __FILE__)

describe R18n::Locales::Sk do
  it "uses Slovak pluralization" do
    sk = R18n.locale('Sk')
    sk.pluralize(0).should == 0
    sk.pluralize(1).should == 1

    sk.pluralize(2).should == 2
    sk.pluralize(3).should == 2
    sk.pluralize(4).should == 2

    sk.pluralize(5).should   == 'n'
    sk.pluralize(21).should  == 'n'
    sk.pluralize(11).should  == 'n'
    sk.pluralize(12).should  == 'n'
    sk.pluralize(22).should  == 'n'
    sk.pluralize(57).should  == 'n'
    sk.pluralize(101).should == 'n'
    sk.pluralize(102).should == 'n'
    sk.pluralize(111).should == 'n'
  end
end
