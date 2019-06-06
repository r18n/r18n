# frozen_string_literal: true

describe R18n::Locales::Fi do
  it 'formats Finnish time' do
    fi = R18n::I18n.new('fi')
    expect(fi.l(Time.utc(2009, 5, 1, 6, 7, 8), :standard, with_seconds: true))
      .to eq('01.05.2009 06.07.08')
  end
end
