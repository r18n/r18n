# frozen_string_literal: true

describe R18n::Locales::Af do
  it 'formats Afrikaans time' do
    af = R18n::I18n.new('af')
    expect(af.l(Time.utc(2009, 5, 1, 6, 7, 8), :standard, with_seconds: true))
      .to eq('01/05/2009, 06:07:08')
  end
end
