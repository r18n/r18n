# frozen_string_literal: true

require File.expand_path('../../spec_helper', __FILE__)

describe R18n::Locales::En do
  it 'formats English date' do
    en = R18n::I18n.new('en')
    expect(en.l(Date.parse('2009-05-01'), :full)).to eq('1st of May, 2009')
    expect(en.l(Date.parse('2009-05-02'), :full)).to eq('2nd of May, 2009')
    expect(en.l(Date.parse('2009-05-03'), :full)).to eq('3rd of May, 2009')
    expect(en.l(Date.parse('2009-05-04'), :full)).to eq('4th of May, 2009')
    expect(en.l(Date.parse('2009-05-11'), :full)).to eq('11th of May, 2009')
    expect(en.l(Date.parse('2009-05-21'), :full)).to eq('21st of May, 2009')
  end
end
