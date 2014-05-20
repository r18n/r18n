require File.expand_path('../../spec_helper', __FILE__)

describe R18n::Locales::Cs do
  it "uses Czech pluralization" do
    cs = R18n.locale('cs')
    expect(cs.pluralize(0)).to eq(0)
    expect(cs.pluralize(1)).to eq(1)

    expect(cs.pluralize(2)).to eq(2)
    expect(cs.pluralize(3)).to eq(2)
    expect(cs.pluralize(4)).to eq(2)

    expect(cs.pluralize(5)).to   eq('n')
    expect(cs.pluralize(21)).to  eq('n')
    expect(cs.pluralize(11)).to  eq('n')
    expect(cs.pluralize(12)).to  eq('n')
    expect(cs.pluralize(22)).to  eq('n')
    expect(cs.pluralize(57)).to  eq('n')
    expect(cs.pluralize(101)).to eq('n')
    expect(cs.pluralize(102)).to eq('n')
    expect(cs.pluralize(111)).to eq('n')
  end
end
