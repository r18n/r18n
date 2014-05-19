require File.expand_path('../../spec_helper', __FILE__)

describe R18n::Locales::Ru do
  it "uses Russian pluralization" do
    ru = R18n.locale('ru')
    expect(ru.pluralize(0)).to eq(0)

    expect(ru.pluralize(1)).to   eq(1)
    expect(ru.pluralize(21)).to  eq(1)
    expect(ru.pluralize(101)).to eq(1)

    expect(ru.pluralize(2)).to   eq(2)
    expect(ru.pluralize(4)).to   eq(2)
    expect(ru.pluralize(22)).to  eq(2)
    expect(ru.pluralize(102)).to eq(2)

    expect(ru.pluralize(5)).to   eq('n')
    expect(ru.pluralize(11)).to  eq('n')
    expect(ru.pluralize(12)).to  eq('n')
    expect(ru.pluralize(57)).to  eq('n')
    expect(ru.pluralize(111)).to eq('n')
  end
end
