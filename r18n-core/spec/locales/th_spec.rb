require File.expand_path('../../spec_helper', __FILE__)

describe R18n::Locales::Th do
  it "uses Thai calendar" do
    th = R18n::I18n.new('th')
    expect(th.l(Time.at(0).utc, '%Y %y')).to eq('2513 13')
    expect(th.l(Time.at(0).utc)).to eq('01/01/2513 00:00')
  end
end
