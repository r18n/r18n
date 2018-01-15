# frozen_string_literal: true

require File.expand_path('../../spec_helper', __FILE__)

describe R18n::Locales::Fa do
  it 'formats Persian numerals' do
    fa = R18n::I18n.new('fa')
    expect(fa.l(1_234_567_890)).to eq('۱٬۲۳۴٬۵۶۷٬۸۹۰')
    expect(fa.l(10.123)).to eq('۱۰٫۱۲۳')
    expect(fa.l(Date.parse('2009-05-01'))).to eq('۲۰۰۹/۰۵/۰۱')
  end
end
