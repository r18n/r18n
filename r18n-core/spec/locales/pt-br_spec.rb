require File.join(File.dirname(__FILE__), '..', 'spec_helper')
require File.join(File.dirname(__FILE__), '..', '..', 'locales', 'pt-br')

describe R18n::Locales::PtBr do
  it "should format Portuguese date" do
    pt_br = R18n::I18n.new('pt-br')
    pt_br.l(Date.parse('2009-10-08'), :full).should ==  '08 de outubro de 2009'
  end
end
