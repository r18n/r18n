# frozen_string_literal: true

describe R18n::Locales::Id do
  it 'formats Indonesian date' do
    id = R18n::I18n.new('id')

    expect(id.l(Date.parse('2009-11-01'), :full)).to eq('1 November 2009')
    expect(id.l(Date.parse('2009-11-02'), :standard)).to eq('02/11/2009')
    expect(id.l(Date.parse('2009-11-21'), '%d/%b/%y')).to eq('21/Nov/09')
  end

  it 'formats Indonesian time' do
    id = R18n::I18n.new('id')
    time = id.l(Time.utc(2009, 5, 1, 6, 7, 8), :standard)
    expect(time).to eq('01/05/2009 pukul 06.07')
  end

  it 'formats Indonesian time with seconds' do
    id = R18n::I18n.new('id')
    time = id.l(Time.utc(2009, 5, 1, 6, 7, 8), :standard, with_seconds: true)
    expect(time).to eq('01/05/2009 pukul 06.07.08')
  end
end
