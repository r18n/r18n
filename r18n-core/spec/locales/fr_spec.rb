require File.expand_path('../../spec_helper', __FILE__)

describe R18n::Locales::Fr do
  it "formats French date" do
    fr = R18n::I18n.new('fr')
    fr.l(Date.parse('2009-07-01'), :full).should ==  '1er juillet 2009'
    fr.l(Date.parse('2009-07-02'), :full).should ==  ' 2 juillet 2009'
  end
end
