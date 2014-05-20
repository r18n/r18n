# encoding: utf-8
require File.expand_path('../spec_helper', __FILE__)

describe 'Rails filters' do
  it "uses named variables" do
    i18n = R18n::Translation.new(EN, '', :locale => EN,
      :translations => { 'echo' => 'Value is %{value}' })

    expect(i18n.echo(:value => 'R18n')).to eq 'Value is R18n'
    expect(i18n.echo(:value => -5.5)).to eq 'Value is −5.5'
    expect(i18n.echo(:value => 5000)).to eq 'Value is 5,000'
    expect(i18n.echo(:value => '<b>')).to eq 'Value is &lt;b&gt;'
    expect(i18n.echo).to eq 'Value is %{value}'
  end

  it "uses old variables syntax" do
    i18n = R18n::Translation.new(EN, '', :locale => EN,
      :translations => { 'echo' => 'Value is {{value}}' })
    expect(i18n.echo(:value => 'Old')).to eq 'Value is Old'
  end

  it "pluralizes by variable %{count}" do
    i18n = R18n::Translation.new(EN, '', :locale => EN,
      :translations => {
        'users' => R18n::Typed.new('pl', {
          0 => 'no users',
          1 => '1 user',
          'n' => '%{count} users'
        })
      })

    expect(i18n.users(:count => 0)).to eq 'no users'
    expect(i18n.users(:count => 1)).to eq '1 user'
    expect(i18n.users(:count => 5)).to eq '5 users'
  end
end
