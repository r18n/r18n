# frozen_string_literal: true

describe R18n::Locales::Pl do
  it 'uses Polish pluralization' do
    pl = R18n.locale('pl')
    expect(pl.pluralize(0)).to eq(0)
    expect(pl.pluralize(1)).to eq(1)

    expect(pl.pluralize(2)).to   eq(2)
    expect(pl.pluralize(4)).to   eq(2)
    expect(pl.pluralize(22)).to  eq(2)
    expect(pl.pluralize(102)).to eq(2)

    expect(pl.pluralize(5)).to   eq('n')
    expect(pl.pluralize(11)).to  eq('n')
    expect(pl.pluralize(12)).to  eq('n')
    expect(pl.pluralize(21)).to  eq('n')
    expect(pl.pluralize(57)).to  eq('n')
    expect(pl.pluralize(101)).to eq('n')
    expect(pl.pluralize(111)).to eq('n')
    expect(pl.pluralize(112)).to eq('n')
  end
end
