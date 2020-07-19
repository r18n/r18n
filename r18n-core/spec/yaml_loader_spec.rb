# frozen_string_literal: true

describe R18n::Loader::YAML do
  before :all do
    R18n::Filters.add('my', :my) { |i| i }
  end

  after :all do
    R18n::Filters.delete(:my)
  end

  let(:loader) { R18n::Loader::YAML.new(general_translations_dir) }

  it 'returns dir with translations' do
    expect(loader.dir).to eq(general_translations_dir)
  end

  it 'equals to another YAML loader with same dir' do
    expect(loader).to eq(R18n::Loader::YAML.new(general_translations_dir))
    expect(loader).not_to eq(
      Class.new(R18n::Loader::YAML).new(general_translations_dir)
    )
  end

  it 'returns all available translations' do
    expect(loader.available).to match_array([
      R18n.locale('ru'),
      R18n.locale('en'),
      R18n.locale('nolocale')
    ])
  end

  it 'loads translation' do
    expect(loader.load(R18n.locale('ru'))).to eq(
      'one' => 'Один',
      'in' => { 'another' => { 'level' => 'Иерархический' } },
      'typed' => R18n::Typed.new('my', 'value')
    )
  end

  it 'returns hash by dir' do
    expect(loader.hash).to eq(
      R18n::Loader::YAML.new(general_translations_dir).hash
    )
  end

  it 'loads in dir recursively' do
    loader = R18n::Loader::YAML.new(translations_dir)
    expect(loader.available).to match_array([
      R18n.locale('ru'),
      R18n.locale('ru-ru'),
      R18n.locale('en'),
      R18n.locale('en-us'),
      R18n.locale('en-gb'),
      R18n.locale('fr'),
      R18n.locale('notransl'),
      R18n.locale('nolocale')
    ])

    translation = loader.load(R18n.locale('en'))
    expect(translation['two']).to       eq('Two')
    expect(translation['in']['two']).to eq('Two')
    expect(translation['ext']).to       eq('Extension')
    expect(translation['deep']).to      eq('Deep one')
  end
end
