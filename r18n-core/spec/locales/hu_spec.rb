# frozen_string_literal: true

describe R18n::Locales::Hu do
  it 'uses Hungarian digits groups' do
    hu = R18n::I18n.new('hu')
    expect(hu.l(1000)).to    eq('1000')
    expect(hu.l(10_000)).to  eq('10 000')
    expect(hu.l(-10_000)).to eq('−10 000')
    expect(hu.l(100_000)).to eq('100 000')
  end

  it 'uses Hungarian time format' do
    hu = R18n::I18n.new('hu')
    expect(hu.l(Time.at(0).utc)).to        eq('1970. 01. 01., 00:00')
    expect(hu.l(Time.at(0).utc, :full)).to eq('1970. január  1., 00:00')
  end
end
