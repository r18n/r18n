# frozen_string_literal: true

describe R18n::Locales::Fr do
  it 'formats French date' do
    fr = R18n::I18n.new('fr')
    expect(fr.l(Date.parse('2009-07-01'), :full)).to eq('1er juillet 2009')
    expect(fr.l(Date.parse('2009-07-02'), :full)).to eq('2 juillet 2009')
  end
end
