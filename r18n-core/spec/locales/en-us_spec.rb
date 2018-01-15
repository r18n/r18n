# frozen_string_literal: true

describe R18n::Locales::EnUs do
  it 'formats American English date' do
    en_us = R18n::I18n.new('en-US')
    expect(en_us.l(Date.parse('2009-05-01'), :full)).to eq('May 1st, 2009')
    expect(en_us.l(Date.parse('2009-05-02'), :full)).to eq('May 2nd, 2009')
    expect(en_us.l(Date.parse('2009-05-03'), :full)).to eq('May 3rd, 2009')
    expect(en_us.l(Date.parse('2009-05-04'), :full)).to eq('May 4th, 2009')
    expect(en_us.l(Date.parse('2009-05-11'), :full)).to eq('May 11th, 2009')
    expect(en_us.l(Date.parse('2009-05-21'), :full)).to eq('May 21st, 2009')
  end
end
