# frozen_string_literal: true

describe R18n::Locales::EnUS do
  it 'formats American Spanish time' do
    es_us = R18n::I18n.new('es-US')
    expect(
      es_us.l(Time.utc(2009, 5, 1, 6, 7, 8), :standard, with_seconds: true)
    )
      .to eq('05/01/2009 06:07:08 AM')
  end
end
