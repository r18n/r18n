# frozen_string_literal: true

describe R18n::Backend do
  before do
    I18n.load_path = [general_files]
    I18n.backend = R18n::Backend.new
    R18n.default_places = R18n::Loader::Rails.new
    R18n.set('en')
  end

  it 'returns available locales' do
    expect(I18n.available_locales).to match_array(%i[en ru])
  end

  it 'localizes objects' do
    time = Time.at(0).utc
    date = Date.parse('1970-01-01')

    expect(I18n.l(time)).to eq 'Thu, 01 Jan 1970 00:00:00 +0000'
    expect(I18n.l(date)).to eq '1970-01-01'

    expect(I18n.l(time, format: :short)).to eq '01 Jan 00:00'
    expect(I18n.l(time, format: :full)).to  eq '1st of January, 1970 00:00'

    expect(I18n.l(-5000.5)).to eq '−5,000.5'
  end

  it 'translates by key and scope' do
    expect(I18n.t('in.another.level')).to            eq 'Hierarchical'
    expect(I18n.t(:level, scope: 'in.another')).to   eq 'Hierarchical'
    expect(I18n.t(:'another.level', scope: 'in')).to eq 'Hierarchical'
  end

  it 'uses pluralization and variables' do
    expect(I18n.t('users', count: 0)).to eq '0 users'
    expect(I18n.t('users', count: 1)).to eq '1 user'
    expect(I18n.t('users', count: 5)).to eq '5 users'
  end

  it 'uses another separator' do
    expect(I18n.t('in/another/level', separator: '/')).to eq 'Hierarchical'
  end

  it 'translates array' do
    expect(I18n.t(['in.another.level', 'in.default'])).to eq(
      %w[Hierarchical Default]
    )
  end

  it 'uses default value' do
    expect(I18n.t(:missed, default: 'Default')).to                 eq 'Default'
    expect(I18n.t(:missed, default: :default, scope: :in)).to      eq 'Default'
    expect(I18n.t(:missed, default: %i[also_no in.default])).to    eq 'Default'
    expect(I18n.t(:missed, default: proc { |key| key.to_s })).to   eq 'missed'
  end

  it 'raises error on no translation' do
    expect { I18n.backend.translate(:en, :missed) }
      .to raise_error(::I18n::MissingTranslationData)

    expect { I18n.t(:missed) }.to raise_error(::I18n::MissingTranslationData)
  end

  it 'reloads translations' do
    expect { I18n.t(:other) }.to raise_error(::I18n::MissingTranslationData)
    I18n.load_path << other_files
    I18n.reload!
    expect(I18n.t(:other)).to eq 'Other'
  end

  it 'returns plain classes' do
    ActiveSupport::SafeBuffer if ActiveSupport.autoload?(:SafeBuffer)
    expect(I18n.t('in.another.level').class).to eq ActiveSupport::SafeBuffer

    allow_any_instance_of(R18n::TranslatedString)
      .to receive(:respond_to?).with(:html_safe).and_return false

    expect(I18n.t('in.another.level').class).to eq String

    expect(I18n.t('in.another').class).to eq Hash
  end

  ## https://github.com/rubocop-hq/rubocop/issues/7436#issuecomment-578766498
  # rubocop:disable Style/FormatStringToken
  it 'returns correct unpluralized hash' do
    expect(I18n.t('users')).to eq(one: '1 user', other: '%{count} users')
  end
  # rubocop:enable Style/FormatStringToken

  it 'corrects detect untranslated, whem path is deeper than string' do
    expect { I18n.t('in.another.level.deeper') }
      .to raise_error(::I18n::MissingTranslationData)

    expect { I18n.t('in.another.level.go.deeper') }
      .to raise_error(::I18n::MissingTranslationData)
  end

  it "doesn't call String methods" do
    expect(I18n.t('in.another').class).to eq Hash
  end

  it "doesn't call object methods" do
    expect { I18n.t('in.another.level.to_sym') }
      .to raise_error(::I18n::MissingTranslationData)
  end

  it 'works deeper pluralization' do
    expect(I18n.t('users.other', count: 5)).to eq '5 users'
  end

  it 'returns hash with symbols keys' do
    expect(I18n.t('in')).to eq(
      another: { level: 'Hierarchical' },
      default: 'Default'
    )
  end

  it 'changes locale in place' do
    I18n.load_path << pl_files
    expect(I18n.t('users', count: 5)).to eq '5 users'
    expect(I18n.t('users', count: 5, locale: :ru)).to eq 'Много'

    expect(I18n.l(Date.parse('1970-01-01'), locale: :ru)).to eq '01.01.1970'
  end

  it 'has transliterate method' do
    expect(I18n.transliterate('café')).to eq 'cafe'
  end
end
