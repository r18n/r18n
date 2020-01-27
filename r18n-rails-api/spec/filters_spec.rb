# frozen_string_literal: true

describe 'Rails filters' do
  it 'uses old variables syntax' do
    i18n = R18n::Translation.new(
      EN, '', locale: EN, translations: { 'echo' => 'Value is {{value}}' }
    )
    expect(i18n.echo(value: 'Old')).to eq 'Value is Old'
  end

  # rubocop:disable Style/FormatStringToken
  it 'pluralizes by variable %{count}' do
    i18n = R18n::Translation.new(
      EN, '', locale: EN, translations: {
        'users' => R18n::Typed.new(
          'pl',
          0 => 'no users',
          1 => '1 user',
          'n' => '%{count} users'
        )
      }
    )

    expect(i18n.users(count: 0)).to eq 'no users'
    expect(i18n.users(count: 1)).to eq '1 user'
    expect(i18n.users(count: 5)).to eq '5 users'
  end
  # rubocop:enable Style/FormatStringToken
end
