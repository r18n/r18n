require File.join(File.dirname(__FILE__), '..', 'spec_helper')
require File.join(File.dirname(__FILE__), '..', '..', 'locales', 'es')

describe R18n::Locales::Es do
  it "should format Spain date" do
    es = R18n::I18n.new('es')
    es.l(Date.parse('2009-10-08'), :full).should ==  '08 de Octubre de 2009'
  end
end
