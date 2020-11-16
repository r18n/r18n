# frozen_string_literal: true

describe R18n::Filters do
  let(:i18n) { R18n::I18n.new('en', general_translations_dir) }

  before do
    @system  = R18n::Filters.defined.values
    @enabled = R18n::Filters.defined.values.select(&:enabled?)
  end

  after do
    R18n::Filters.defined.each_value do |filter|
      next if @system.include? filter

      R18n::Filters.delete(filter)
    end

    @enabled.each { |i| R18n::Filters.on(i) unless i.enabled? }
    (@system - @enabled).each { |i| R18n::Filters.off(i) if i.enabled? }
  end

  it 'adds new filter' do
    filter = R18n::Filters.add('my', :my_filter) { |i, _config| i }

    expect(filter).to be_kind_of(R18n::Filters::Filter)
    expect(filter.name).to eq(:my_filter)
    expect(filter.types).to eq(['my'])
    expect(filter).to be_enabled

    expect(R18n::Filters.defined).to have_key(:my_filter)

    expect(i18n.my_filter).to eq('value')
    expect(i18n.my_tree_filter).to eq('name' => 'value')
  end

  it 'adds filter for several types' do
    R18n::Filters.add(%w[my your]) { |i, _config| "#{i}1" }
    expect(i18n.my_filter).to   eq('value1')
    expect(i18n.your_filter).to eq('another1')
  end

  it 'uses passive filters' do
    filter = double
    expect(filter).to receive(:process).twice.and_return(1)

    expect(i18n.my_filter).to eq('value')

    R18n::Filters.add('my', :passive, passive: true) { filter.process }

    expect(i18n.my_filter).to eq('value')

    i18n.reload!

    expect(i18n.my_tree_filter).to eq(1)
    expect(i18n.my_filter).to eq(1)
    expect(i18n.my_filter).to eq(1)
  end

  it 'uses cascade filters' do
    R18n::Filters.add('my', :one) { |i, _config| "#{i}1" }
    R18n::Filters.add('my', :two) { |i, _config| "#{i}2" }
    R18n::Filters.add('my', :three, position: 0) { |i, _c| "#{i}3" }
    expect(i18n.my_filter).to eq('value312')
  end

  it 'returns name for nameless filter' do
    R18n::Filters.instance_variable_set(:@last_auto_name, 0)

    expect(R18n::Filters.add('some').name).to eq(1)
    expect(R18n::Filters.add('some', position: 0).name).to eq(2)

    R18n::Filters.add('some', 3)
    expect(R18n::Filters.add('some').name).to eq(4)
  end

  it 'deletes filter by name' do
    R18n::Filters.add('my', :my_filter) { '1' }
    expect(i18n.my_filter).to eq('1')

    R18n::Filters.delete(:my_filter)
    expect(R18n::Filters.defined).not_to have_key(:my_filter)
    expect(i18n.my_filter).to eq('value')
  end

  it 'deletes filter by object' do
    filter = R18n::Filters.add('my') { '1' }
    expect(i18n.my_filter).to eq('1')

    R18n::Filters.delete(filter)
    expect(R18n::Filters.defined).not_to have_key(filter.name)
    expect(i18n.my_filter).to eq('value')
  end

  it 'uses global filters' do
    R18n::Filters.add(String) { |result, _config, a, b| result + a + b }
    R18n::Filters.add(String) { |result, _config| "#{result}!" }

    expect(i18n.one('1', '2')).to eq('One12!')
  end

  it 'turns off filter' do
    R18n::Filters.add('my', :one) { |i, _config| "#{i}1" }
    R18n::Filters.add('my', :two) { |i, _config| "#{i}2" }

    R18n::Filters.off(:one)
    expect(R18n::Filters.defined[:one]).not_to be_enabled
    expect(i18n.my_filter).to eq('value2')

    R18n::Filters.on(:one)
    expect(R18n::Filters.defined[:one]).to be_enabled
    expect(i18n.my_filter).to eq('value12')
  end

  it 'sends config to filter' do
    R18n::Filters.add('my') do |_i, config|
      config[:secret_value] = 1
      config
    end
    expect(i18n.my_filter[:locale]).to eq(i18n.locale)
    expect(i18n.my_filter[:path]).to eq('my_filter')
    expect(i18n.my_filter[:secret_value]).to eq(1)
    expect(i18n.my_filter[:unknown_value]).to be_nil
  end

  it 'sets path in config' do
    R18n::Filters.add(String) do |_i, config|
      config[:path]
    end

    expect(i18n.in.another.level).to eq('in.another.level')
  end

  it 'returns translated string after filters' do
    R18n::Filters.add(String) { |i, _config| "#{i}1" }

    expect(i18n.one).to be_kind_of(R18n::TranslatedString)
    expect(i18n.one.path).to   eq('one')
    expect(i18n.one.locale).to eq(R18n.locale('en'))
  end

  it 'uses one config for cascade filters' do
    R18n::Filters.add('my') { |_content, config| config[:new_secret] ? 2 : 1 }
    expect(i18n.my_filter).to eq(1)

    R18n::Filters.add('my', :second, position: 0) do |content, config|
      config[:new_secret] = true
      content
    end
    expect(i18n.my_filter).to eq(2)
  end

  it 'sends parameters to filter' do
    R18n::Filters.add('my') { |i, _config, a, b| "#{i}#{a}#{b}" }
    expect(i18n['my_filter', 1, 2]).to eq('value12')
    expect(i18n.my_filter(1, 2)).to eq('value12')
  end

  it 'pluralizes translation' do
    expect(i18n.comments(0, 'article')).to eq('no comments for article')
    expect(i18n.comments(1, 'article')).to eq('one comment for article')
    expect(i18n.comments(5, 'article')).to eq('5 comments for article')

    expect(i18n.files(0)).to    eq('0 files')
    expect(i18n.files(-5.5)).to eq('−5.5 files')
    expect(i18n.files(5000)).to eq('5,000 files')
  end

  it "doesn't pluralize without first numeric parameter" do
    expect(i18n.files).to      be_kind_of(R18n::UnpluralizedTranslation)
    expect(i18n.files('')).to  be_kind_of(R18n::UnpluralizedTranslation)
    expect(i18n.files[1]).to   eq('1 file')
    expect(i18n.files.n(5)).to eq('5 files')
  end

  it 'converts first float parameter to number' do
    expect(i18n.files(1.2)).to eq('1 file')
  end

  it 'pluralizes translation without locale' do
    i18n = R18n::I18n.new('nolocale', general_translations_dir)
    expect(i18n.entries(1)).to eq('ONE')
    expect(i18n.entries(5)).to eq('N')
  end

  it 'cans use params in translation' do
    expect(i18n.params(-1, 2)).to eq('Is −1 between −1 and 2?')
  end

  it "substitutes '%2' as param but not value of second param" do
    expect(i18n.params('%2 FIRST', 'SECOND')).to eq(
      'Is %2 FIRST between %2 FIRST and SECOND?'
    )
  end

  # rubocop:disable Style/FormatStringToken
  it 'interpolates named variables' do
    hide_const 'ActiveSupport::SafeBuffer'
    allow_any_instance_of(R18n::TranslatedString)
      .to receive(:respond_to?).and_call_original
    allow_any_instance_of(R18n::TranslatedString)
      .to receive(:respond_to?).with(:html_safe).and_return false

    R18n::Filters.off(:named_variables)
    expect(i18n.echo(value: 'R18n')).to eq 'Value is %{value}'

    R18n::Filters.on(:named_variables)
    expect(i18n.echo(value: 'R18n')).to eq 'Value is R18n'
    expect(i18n.echo(value: -5.5)).to   eq 'Value is −5.5'
    expect(i18n.echo(value: 5000)).to   eq 'Value is 5,000'
    expect(i18n.echo(value: '<b>')).to eq 'Value is <b>'
    expect(i18n.echo).to eq 'Value is %{value}'

    expect(i18n.echo2(value: 'R18n')).to eq 'Value2 is R18n'
    expect(i18n.echo2).to eq 'Value2 is {{value}}'

    translate_hash = Hash.new { |hash, key| hash[key] = key.to_s * 2 }
    expect(i18n.echo3(translate_hash)).to eq(
      'Value3 is value3value3 and value4 is value4value4'
    )
  end
  # rubocop:enable Style/FormatStringToken

  it 'formats untranslated' do
    expect(i18n.in.not.to_s).to   eq('in.[not]')
    expect(i18n.in.not.to_str).to eq('in.[not]')

    expect(i18n.one.not_exists.to_s).to eq('one.[not_exists]')

    R18n::Filters.off(:untranslated)
    expect(i18n.in.not.to_s).to eq('in.not')

    R18n::Filters.add(R18n::Untranslated) do |_v, _c, trans, untrans, path|
      "#{path} #{trans}[#{untrans}]"
    end
    expect(i18n.in.not.to_s).to eq('in.not in.[not]')
  end

  it 'formats translation path' do
    expect(i18n.in.another.to_s).to eq('in.another[]')

    R18n::Filters.off(:untranslated)
    expect(i18n.in.another.to_s).to eq('in.another')

    R18n::Filters.add(R18n::Untranslated) do |_v, _c, trans, untrans, path|
      "#{path} #{trans}[#{untrans}]"
    end
    expect(i18n.in.another.to_s).to eq('in.another in.another[]')
  end

  it 'formats untranslated for web' do
    R18n::Filters.off(:untranslated)
    R18n::Filters.on(:untranslated_html)
    expect(i18n.in.not.to_s).to eq('in.<span style="color: red">[not]</span>')
    expect(i18n['<b>'].to_s).to eq(
      '<span style="color: red">[&lt;b&gt;]</span>'
    )
  end

  it 'allows to set custom filters' do
    R18n::Filters.add(R18n::Untranslated, :a) { |v, _c| "a #{v}" }
    R18n::Filters.off(:a)

    html = R18n::I18n.new(
      'en', general_translations_dir,
      off_filters: :untranslated, on_filters: %i[untranslated_html a]
    )
    expect(html.in.not.to_s).to eq('a in.<span style="color: red">[not]</span>')
  end

  it 'has filter for escape HTML' do
    expect(i18n.html).to eq(
      '&lt;script&gt;true &amp;&amp; false&lt;/script&gt;'
    )
  end

  it 'has disabled global filter for escape HTML' do
    expect(i18n.greater('true')).to eq('1 < 2 is true')

    R18n::Filters.on(:global_escape_html)
    i18n.reload!
    expect(i18n.greater('true')).to eq('1 &lt; 2 is true')
    expect(i18n.html).to eq(
      '&lt;script&gt;true &amp;&amp; false&lt;/script&gt;'
    )
  end

  it 'has filter to disable global HTML escape' do
    expect(i18n.no_escape).to eq('<b>Warning</b>')

    R18n::Filters.on(:global_escape_html)
    i18n.reload!
    expect(i18n.no_escape).to eq('<b>Warning</b>')
  end

  it 'has Markdown filter' do
    expect(i18n.markdown.simple).to eq("<p><strong>Hi!</strong></p>\n")
  end

  it 'has Textile filter' do
    expect(i18n.textile.simple).to eq('<p><em>Hi!</em></p>')
  end

  it 'HTML escapes before Markdown and Textile filters' do
    expect(i18n.markdown.html).to eq("<p><strong>Hi!</strong> <br /></p>\n")
    expect(i18n.textile.html).to  eq('<p><em>Hi!</em><br /></p>')

    R18n::Filters.on(:global_escape_html)
    i18n.reload!
    expect(i18n.markdown.html).to eq(
      "<p><strong>Hi!</strong> &lt;br /&gt;</p>\n"
    )
    expect(i18n.textile.html).to eq(
      '<p><em>Hi!</em>&lt;br /&gt;</p>'
    )
  end

  it 'allows to listen filters adding' do
    expect(R18n::Filters.listen do
      R18n::Filters.add(String, :a) { nil }
    end).to eq([R18n::Filters.defined[:a]])
  end

  it 'escapes variables if ActiveSupport is loaded' do
    expect(i18n.escape_params('<br>')).to eq('<b>&lt;br&gt;</b>')

    R18n::Filters.on(:global_escape_html)
    i18n.reload!

    expect(i18n.greater('<b>'.html_safe)).to eq('1 &lt; 2 is <b>')

    R18n::Filters.on(:named_variables)

    expect(i18n.echo(value: '<b>')).to eq 'Value is &lt;b&gt;'
  end
end
