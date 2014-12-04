require File.expand_path('../spec_helper', __FILE__)

describe R18n do
  include R18n::Helpers

  after do
    R18n.default_loader = R18n::Loader::YAML
    R18n.default_places = nil
    R18n.reset!
  end

  it "stores I18n" do
    i18n = R18n::I18n.new('en')
    R18n.set(i18n)
    expect(R18n.get).to eq(i18n)

    R18n.reset!
    expect(R18n.get).to be_nil
  end

  it "sets setter to I18n" do
    i18n = R18n::I18n.new('en')
    R18n.set(i18n)

    i18n = R18n::I18n.new('ru')
    R18n.set { i18n }

    expect(R18n.get).to eq(i18n)
  end

  it "creates I18n object by shortcut" do
    R18n.set('en', DIR)
    expect(R18n.get).to be_kind_of(R18n::I18n)
    expect(R18n.get.locales).to eq([R18n.locale('en')])
    expect(R18n.get.translation_places).to eq([R18n::Loader::YAML.new(DIR)])
  end

  it "allows to return I18n arguments in setter block" do
    R18n.set { 'en' }
    expect(R18n.get.locales).to eq([R18n.locale('en')])
  end

  it "clears cache" do
    R18n.cache[:a] = 1
    R18n.clear_cache!
    expect(R18n.cache).to be_empty
  end

  it "resets I18n objects and cache" do
    R18n.cache[:a] = 1
    R18n.set('en')
    R18n.thread_set('en')

    R18n.reset!
    expect(R18n.get).to be_nil
    expect(R18n.cache).to be_empty
  end

  it "stores I18n via thread_set" do
    i18n = R18n::I18n.new('en')
    R18n.thread_set(i18n)
    expect(R18n.get).to eq(i18n)

    i18n = R18n::I18n.new('ru')
    R18n.thread_set { i18n }
    expect(R18n.get).to eq(i18n)
  end

  it "allows to temporary change locale" do
    R18n.default_places = DIR
    expect(R18n.change('en').locales).to eq([R18n.locale('en')])
    expect(R18n.change('en').translation_places.size).to eq(1)
    expect(R18n.change('en').translation_places.first.dir).to eq(DIR.to_s)
  end

  it "allows to temporary change current locales" do
    R18n.set('ru')
    expect(R18n.change('en').locales).to eq(
      [R18n.locale('en'), R18n.locale('ru')])
    expect(R18n.change('en').translation_places).to eq(
      R18n.get.translation_places)
    expect(R18n.get.locale.code).to eq('ru')
  end

  it "allows to get Locale to temporary change" do
    R18n.set('ru')
    expect(R18n.change(R18n.locale('en')).locale.code).to eq('en')
  end

  it "has shortcut to load locale" do
    expect(R18n.locale('ru')).to eq(R18n::Locale.load('ru'))
  end

  it "stores default loader class" do
    expect(R18n.default_loader).to eq(R18n::Loader::YAML)
    R18n.default_loader = Class
    expect(R18n.default_loader).to be_kind_of(Class)
  end

  it "stores cache" do
    expect(R18n.cache).to be_kind_of(Hash)

    R18n.cache = { 1 => 2 }
    expect(R18n.cache).to eq({ 1 => 2 })

    R18n.clear_cache!
    expect(R18n.cache).to eq({ })
  end

  it "maps hash" do
    hash = R18n::Utils.hash_map({ 'a' => 1, 'b' => 2 }) { |k, v|
      [k + 'a', v + 1]
    }
    expect(hash).to eq({ 'aa' => 2, 'ba' => 3 })
  end

  it "merges hash recursively" do
    a = { a: 1, b: { ba: 1, bb: 1}, c: 1 }
    b = {       b: { bb: 2, bc: 2}, c: 2 }

    R18n::Utils.deep_merge!(a, b)
    expect(a).to eq({ a: 1, b: { ba: 1, bb: 2, bc: 2 }, c: 2 })
  end

  it "has l and t methods" do
    R18n.set('en')
    expect(t.yes).to eq('Yes')
    expect(l(Time.at(0).utc)).to eq('01/01/1970 00:00')
  end

  it "has helpers mixin" do
    obj = R18n::I18n.new('en')
    R18n.set(obj)

    expect(r18n).to  eq(obj)
    expect(i18n).to  eq(obj)
    expect(t.yes).to eq('Yes')
    expect(l(Time.at(0).utc)).to eq('01/01/1970 00:00')
  end

  it "returns available translations" do
    expect(R18n.available_locales(DIR)).to match_array([R18n.locale('nolocale'),
                                           R18n.locale('ru'),
                                           R18n.locale('en')])
  end

  it "uses default places" do
    R18n.default_places = DIR
    R18n.set('en')
    expect(t.one).to eq('One')
    expect(R18n.available_locales).to match_array([R18n.locale('ru'),
                                      R18n.locale('en'),
                                      R18n.locale('nolocale')])
  end

  it "sets default places by block" do
    R18n.default_places { DIR }
    expect(R18n.default_places).to eq(DIR)
  end

  it "allows to ignore default places" do
    R18n.default_places = DIR
    i18n = R18n::I18n.new('en', nil)
    expect(i18n.one).not_to be_translated
  end
end
