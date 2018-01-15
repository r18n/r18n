# frozen_string_literal: true

require File.expand_path('../../spec_helper', __FILE__)

describe R18n::Locales::It do
  it 'formats Italian date' do
    italian = R18n::I18n.new('it')
    expect(italian.l(Date.parse('2009-07-01'), :full)).to eq('1º luglio 2009')
    expect(italian.l(Date.parse('2009-07-02'), :full)).to eq(' 2 luglio 2009')
    expect(italian.l(Date.parse('2009-07-12'), :full)).to eq('12 luglio 2009')
  end
end
