require File.expand_path('../spec_helper', __FILE__)

describe "r18n-desktop" do
  include R18n::Helpers

  before(:each) do
    R18n.reset!
  end

  it "returns array of system locales" do
    locale = R18n::I18n.system_locale
    expect(locale.class).to eq String
    expect(locale).not_to be_empty
  end

  it "loads I18n from system environment" do
    R18n.from_env
    expect(r18n.class).to eq R18n::I18n
    expect(r18n.locale).not_to be_empty if String == r18n.locale.class
    expect(R18n.get).to eq r18n
  end

  it "loads i18n from system environment using specified order" do
    R18n.from_env(nil, 'en')
    expect(r18n.locale).to eq R18n.locale('en')
    expect(R18n.get).to eq r18n
  end

  it "allows to overide autodetect by LANG environment" do
    allow(R18n::I18n).to receive(:system_locale) { 'ru' }
    ENV['LANG'] = 'en'
    R18n.from_env
    expect(r18n.locale).to eq R18n.locale('en')
  end
end
