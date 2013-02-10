# encoding: utf-8
require File.expand_path('../spec_helper', __FILE__)

describe R18n::Translation do

  it "should return unstranslated string if translation isn't found" do
    i18n = R18n::I18n.new('en', DIR)
    i18n.not.exists.should be_a(R18n::Untranslated)
    i18n.not.exists.should_not be_translated
    (i18n.not.exists | 'default').should == 'default'
    i18n.not.exists.locale.should == R18n.locale('en')

    i18n.not.exists.should == i18n.not.exists
    i18n.not.exists.should_not == i18n.not.exists2

    (i18n.in | 'default').should == 'default'

    i18n.one.should be_translated
    (i18n.one | 'default').should == 'One'
  end

  it "should return html escaped string" do
    klass = Class.new(R18n::TranslatedString) do
      def html_safe
        '2'
      end
    end
    str = klass.new('1', nil, nil)

    str.should be_html_safe
    str.html_safe.should == '2'
  end

  it "should load use hierarchical translations" do
    i18n = R18n::I18n.new(['ru', 'en'], DIR)
    i18n.in.another.level.should == 'Иерархический'
    i18n[:in][:another][:level].should == 'Иерархический'
    i18n['in']['another']['level'].should == 'Иерархический'
    i18n.only.english.should == 'Only in English'
  end

  it "should save path for translation" do
    i18n = R18n::I18n.new('en', DIR)

    i18n.in.another.level.path.should == 'in.another.level'

    i18n.in.another.not.exists.path.should == 'in.another.not.exists'
    i18n.in.another.not.exists.untranslated_path.should == 'not.exists'
    i18n.in.another.not.exists.translated_path.should == 'in.another.'

    i18n.not.untranslated_path.should == 'not'
    i18n.not.translated_path.should == ''
  end

  it "should return translation keys" do
    i18n = R18n::I18n.new('en', [DIR, TWO])
    i18n.in.translation_keys.should =~ ['another', 'two']
  end

  it "should return string with locale info" do
    i18n = R18n::I18n.new(['no-LC', 'en'], DIR)
    i18n.one.locale.should == R18n::UnsupportedLocale.new('no-LC')
    i18n.two.locale.should == R18n.locale('en')
  end

  it "should filter typed data" do
    en = R18n.locale('en')
    translation = R18n::Translation.new(en, '', :locale => en, :translations =>
      { 'count' => R18n::Typed.new('pl', { 1 => 'one', 'n' => 'many' }) })

    translation.count(1).should == 'one'
    translation.count(5).should == 'many'
  end

  it "should return hash of translations" do
    i18n = R18n::I18n.new('en', DIR)
    i18n.in.to_hash.should == {
      'another' => { 'level' => 'Hierarchical' }
    }
  end

  it "should return untranslated, when we go deeper string" do
    en = R18n.locale('en')
    translation = R18n::Translation.new(en, '',
      :locale => en, :translations => { 'a' => 'A' })

    translation.a.no_tr.should be_a(R18n::Untranslated)
    translation.a.no_tr.translated_path.should   == 'a.'
    translation.a.no_tr.untranslated_path.should == 'no_tr'
  end

  it "should inspect translation" do
    en = R18n.locale('en')

    translation = R18n::Translation.new(en, 'a',
      :locale => en, :translations => { 'a' => 'A' })
    translation.inspect.should == 'Translation `a` for en {"a"=>"A"}'

    translation = R18n::Translation.new(en, '',
      :locale => en, :translations => { 'a' => 'A' })
    translation.inspect.should == 'Translation root for en {"a"=>"A"}'

    translation = R18n::Translation.new(en, '')
    translation.inspect.should == 'Translation root for en {}'
  end

end
