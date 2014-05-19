require File.expand_path('../../spec_helper', __FILE__)

describe R18n::Locales::Sk do
  it "uses Slovak pluralization" do
    sk = R18n.locale('Sk')
    expect(sk.pluralize(0)).to eq(0)
    expect(sk.pluralize(1)).to eq(1)

    expect(sk.pluralize(2)).to eq(2)
    expect(sk.pluralize(3)).to eq(2)
    expect(sk.pluralize(4)).to eq(2)

    expect(sk.pluralize(5)).to   eq('n')
    expect(sk.pluralize(21)).to  eq('n')
    expect(sk.pluralize(11)).to  eq('n')
    expect(sk.pluralize(12)).to  eq('n')
    expect(sk.pluralize(22)).to  eq('n')
    expect(sk.pluralize(57)).to  eq('n')
    expect(sk.pluralize(101)).to eq('n')
    expect(sk.pluralize(102)).to eq('n')
    expect(sk.pluralize(111)).to eq('n')
  end
end
