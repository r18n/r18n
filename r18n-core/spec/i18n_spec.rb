# frozen_string_literal: true

describe R18n::I18n do
  before do
    @extension_places = R18n.extension_places.clone
  end

  after do
    R18n::I18n.default = 'en'
    R18n.default_loader = R18n::Loader::YAML
    R18n.extension_places = @extension_places
  end

  it 'parses HTTP_ACCEPT_LANGUAGE' do
    expect(R18n::I18n.parse_http(nil)).to eq([])
    expect(R18n::I18n.parse_http('')).to eq([])
    expect(R18n::I18n.parse_http('ru,en;q=0.9')).to eq(%w[ru en])
    expect(R18n::I18n.parse_http('ru;q=0.8,en;q=0.9')).to eq(%w[en ru])
  end

  it 'has default locale' do
    R18n::I18n.default = 'ru'
    expect(R18n::I18n.default).to eq('ru')
  end

  it 'loads locales' do
    i18n = R18n::I18n.new('en', DIR)
    expect(i18n.locales).to eq([R18n.locale('en')])

    i18n = R18n::I18n.new(['ru', 'nolocale-DL'], DIR)
    expect(i18n.locales).to eq([
      R18n.locale('ru'),
      R18n::UnsupportedLocale.new('nolocale-DL'),
      R18n::UnsupportedLocale.new('nolocale'),
      R18n.locale('en')
    ])
  end

  it 'returns translations loaders' do
    i18n = R18n::I18n.new('en', DIR)
    expect(i18n.translation_places).to eq([R18n::Loader::YAML.new(DIR)])
  end

  it 'loads translations by loader' do
    loader = Class.new do
      def available
        [R18n.locale('en')]
      end

      def load(_locale)
        { 'custom' => 'Custom' }
      end
    end
    expect(R18n::I18n.new('en', loader.new).custom).to eq('Custom')
  end

  it 'passes parameters to default loader' do
    loader = Class.new do
      def initialize(param)
        @param = param
      end

      def available
        [R18n.locale('en')]
      end

      def load(_locale)
        { 'custom' => @param }
      end
    end
    R18n.default_loader = loader
    expect(R18n::I18n.new('en', 'default').custom).to eq('default')
  end

  it 'loads translations' do
    i18n = R18n::I18n.new(%w[ru en], DIR)
    expect(i18n.one).to    eq('Один')
    expect(i18n[:one]).to  eq('Один')
    expect(i18n['one']).to eq('Один')
    expect(i18n.only.english).to eq('Only in English')
  end

  it 'loads translations from several dirs' do
    i18n = R18n::I18n.new(%w[nolocale en], [TWO, DIR])
    expect(i18n.in.two).to eq('Two')
    expect(i18n.in.another.level).to eq('Hierarchical')
  end

  it 'uses extension places' do
    R18n.extension_places << EXT

    i18n = R18n::I18n.new('en', DIR)
    expect(i18n.ext).to eq('Extension')
    expect(i18n.one).to eq('One')
  end

  it "doesn't use extension without app translations with same locale" do
    R18n.extension_places << EXT

    i18n = R18n::I18n.new(%w[notransl en], DIR)
    expect(i18n.ext).to eq('Extension')
  end

  it 'ignores case on loading' do
    i18n = R18n::I18n.new('nolocale', [DIR])
    expect(i18n.one).to eq('ONE')

    i18n = R18n::I18n.new('nolocale', [DIR])
    expect(i18n.one).to eq('ONE')
  end

  it 'loads default translation' do
    i18n = R18n::I18n.new('nolocale', DIR)
    expect(i18n.one).to eq('ONE')
    expect(i18n.two).to eq('Two')
  end

  it 'loads sublocales for first locale' do
    R18n::I18n.default = 'notransl'

    i18n = R18n::I18n.new('ru', DIR)
    expect(i18n.one).to eq('Один')
    expect(i18n.two).to eq('Two')
  end

  it 'loads base translations from parent locale' do
    i18n = R18n::I18n.new('en-US', File.join(TRANSLATIONS, 'with_regions'))
    expect(i18n.save).to eq('Save')
  end

  it 'returns available translations' do
    i18n = R18n::I18n.new('en', DIR)
    expect(i18n.available_locales).to match_array([
      R18n.locale('nolocale'),
      R18n.locale('ru'),
      R18n.locale('en')
    ])
  end

  it 'caches translations' do
    counter = CounterLoader.new('en')

    R18n::I18n.new('en', counter)
    expect(counter.loaded).to eq(1)

    R18n::I18n.new('en', counter)
    expect(counter.loaded).to eq(1)

    R18n.clear_cache!
    R18n::I18n.new('en', counter)
    expect(counter.loaded).to eq(2)
  end

  it "doesn't clear cache when custom filters are specified" do
    counter = CounterLoader.new('en')

    R18n::I18n.new(
      'en', counter, off_filters: :untranslated, on_filters: :untranslated_html
    )
    expect(counter.loaded).to eq(1)

    R18n::I18n.new(
      'en', counter, off_filters: :untranslated, on_filters: :untranslated_html
    )
    expect(counter.loaded).to eq(1)
  end

  it 'caches translations by used locales' do
    counter = CounterLoader.new('en', 'ru')

    R18n::I18n.new('en', counter)
    expect(counter.loaded).to eq(1)

    R18n::I18n.new(%w[en fr], counter)
    expect(counter.loaded).to eq(1)

    R18n::I18n.new(%w[en ru], counter)
    expect(counter.loaded).to eq(3)

    R18n::I18n.new(%w[ru en], counter)
    expect(counter.loaded).to eq(5)
  end

  it 'caches translations by places' do
    counter = CounterLoader.new('en', 'ru')

    R18n::I18n.new('en', counter)
    expect(counter.loaded).to eq(1)

    R18n::I18n.new('en', [counter, DIR])
    expect(counter.loaded).to eq(2)

    R18n.extension_places << EXT
    R18n::I18n.new('en', counter)
    expect(counter.loaded).to eq(3)

    same = CounterLoader.new('en', 'ru')
    R18n::I18n.new('en', same)
    expect(same.loaded).to eq(0)

    different = CounterLoader.new('en', 'fr')
    R18n::I18n.new('en', different)
    expect(different.loaded).to eq(1)
  end

  it 'reloads translations' do
    loader = Class.new do
      def available
        [R18n.locale('en')]
      end

      def load(_locale)
        @answer ||= 0
        @answer  += 1
        { 'one' => @answer }
      end
    end

    i18n = R18n::I18n.new('en', loader.new)
    expect(i18n.one).to eq(1)

    i18n.reload!
    expect(i18n.one).to eq(2)
  end

  it 'returns translations' do
    i18n = R18n::I18n.new('en', DIR)
    expect(i18n.t).to be_kind_of(R18n::Translation)
    expect(i18n.t.one).to eq('One')
  end

  it 'returns first locale with locale file' do
    i18n = R18n::I18n.new(%w[notransl nolocale ru en], DIR)
    expect(i18n.locale).to      eq(R18n.locale('nolocale'))
    expect(i18n.locale.base).to eq(R18n.locale('ru'))
  end

  it 'localizes objects' do
    i18n = R18n::I18n.new('ru')

    expect(i18n.l(-123_456_789)).to eq('−123 456 789')
    expect(i18n.l(-12_345.67)).to   eq('−12 345,67')

    time = Time.utc(2014, 5, 6, 7, 8, 9)
    expect(i18n.l(time, '%A'))
      .to eq('Вторник')
    expect(i18n.l(time, :month))
      .to eq('Май')
    expect(i18n.l(time, :standard))
      .to eq('06.05.2014 07:08')
    expect(i18n.l(time, :standard, with_seconds: true))
      .to eq('06.05.2014 07:08:09')
    expect(i18n.l(time, :full))
      .to eq('6 мая 2014 07:08')
    expect(i18n.l(time, :full, with_seconds: true))
      .to eq('6 мая 2014 07:08:09')

    expect(i18n.l(Date.new(0))).to eq('01.01.0000')
  end

  it 'returns marshalizable values' do
    i18n    = R18n::I18n.new('en', DIR, off_filters: :untranslated,
                                        on_filters:  :untranslated_html)
    demarsh = Marshal.load(Marshal.dump(i18n.t.one))

    expect(i18n.t.one).to        eq(demarsh)
    expect(i18n.t.one.path).to   eq(demarsh.path)
    expect(i18n.t.one.locale).to eq(demarsh.locale)

    demarsh = Marshal.load(Marshal.dump(i18n.t.no_translation))
    expect(i18n.t.no_translation).to eq(demarsh)
  end
end
