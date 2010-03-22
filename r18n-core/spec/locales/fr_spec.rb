require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe R18n::Locales::Fr do
  it "should format French date" do
    fr = R18n::I18n.new('fr')
    fr.l(Date.parse('2009-07-01'), :full).should ==  '1er juillet 2009'
    fr.l(Date.parse('2009-07-02'), :full).should ==  ' 2 juillet 2009'
  end
end
