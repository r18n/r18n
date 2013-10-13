# encoding: utf-8
require File.expand_path('../spec_helper', __FILE__)

describe R18n::Filters do
  before do
    @system  = R18n::Filters.defined.values
    @enabled = R18n::Filters.defined.values.reject { |i| !i.enabled? }
    @i18n = R18n::I18n.new('en', DIR)
    @i18n.reload!
  end

  after do
    R18n::Filters.defined.values.each do |filter|
      next if @system.include? filter
      R18n::Filters.delete(filter)
    end

    @enabled.each { |i| R18n::Filters.on(i) unless i.enabled? }
    (@system - @enabled).each { |i| R18n::Filters.off(i) if i.enabled? }
  end

  it "adds new filter" do
    filter = R18n::Filters.add('my', :my_filter) { |i, config| i }

    filter.should be_a(R18n::Filters::Filter)
    filter.name.should == :my_filter
    filter.types.should == ['my']
    filter.should be_enabled

    R18n::Filters.defined.should have_key(:my_filter)

    @i18n.reload!
    @i18n.my_filter.should == 'value'
    @i18n.my_tree_filter.should == {'name' => 'value'}
  end

  it "adds filter for several types" do
    filter = R18n::Filters.add(['my', 'your']) { |i, config| i + '1' }
    @i18n.reload!
    @i18n.my_filter.should   == 'value1'
    @i18n.your_filter.should == 'another1'
  end

  it "uses passive filters" do
    filter = double()
    filter.should_receive(:process).twice.and_return(1)

    R18n::Filters.add('my', :passive, :passive => true) { filter.process }

    @i18n.my_filter.should.should == 'value'
    @i18n.reload!

    @i18n.my_tree_filter.should == 1
    @i18n.my_filter.should == 1
    @i18n.my_filter.should == 1
  end

  it "uses cascade filters" do
    filter = R18n::Filters.add('my', :one) { |i, config| i + '1' }
    filter = R18n::Filters.add('my', :two) { |i, config| i + '2' }
    filter = R18n::Filters.add('my', :three, :position => 0) { |i, c| i + '3' }
    @i18n.my_filter.should == 'value312'
  end

  it "returns name for nameless filter" do
    R18n::Filters.instance_variable_set(:@last_auto_name, 0)

    R18n::Filters.add('some').name.should == 1
    R18n::Filters.add('some', :position => 0).name.should == 2

    R18n::Filters.add('some', 3)
    R18n::Filters.add('some').name.should == 4
  end

  it "deletes filter by name" do
    R18n::Filters.add('my', :my_filter) { '1' }
    @i18n.my_filter.should == '1'

    R18n::Filters.delete(:my_filter)
    R18n::Filters.defined.should_not have_key(:my_filter)
    @i18n.my_filter.should == 'value'
  end

  it "deletes filter by object" do
    filter = R18n::Filters.add('my') { '1' }
    @i18n.my_filter.should == '1'

    R18n::Filters.delete(filter)
    R18n::Filters.defined.should_not have_key(filter.name)
    @i18n.my_filter.should == 'value'
  end

  it "uses global filters" do
    R18n::Filters.add(String) { |result, config, a, b| result + a + b }
    R18n::Filters.add(String) { |result, config| result + '!' }

    @i18n.one('1', '2').should == 'One12!'
  end

  it "turns off filter" do
    filter = R18n::Filters.add('my', :one) { |i, config| i + '1' }
    filter = R18n::Filters.add('my', :two) { |i, config| i + '2' }

    R18n::Filters.off(:one)
    R18n::Filters.defined[:one].should_not be_enabled
    @i18n.my_filter.should == 'value2'

    R18n::Filters.on(:one)
    R18n::Filters.defined[:one].should be_enabled
    @i18n.my_filter.should == 'value12'
  end

  it "sends config to filter" do
    R18n::Filters.add('my') do |i, config|
      config[:secret_value] = 1
      config
    end
    @i18n.my_filter[:locale].should == @i18n.locale
    @i18n.my_filter[:path].should == 'my_filter'
    @i18n.my_filter[:secret_value].should == 1
    @i18n.my_filter[:unknown_value].should be_nil
  end

  it "sets path in config" do
    R18n::Filters.add(String) do |i, config|
      config[:path]
    end

    @i18n.in.another.level.should == 'in.another.level'
  end

  it "returns translated string after filters" do
    R18n::Filters.add(String) { |i, config| i + '1' }

    @i18n.one.should be_a(R18n::TranslatedString)
    @i18n.one.path.should   == 'one'
    @i18n.one.locale.should == R18n.locale('en')
  end

  it "uses one config for cascade filters" do
    R18n::Filters.add('my') { |content, config| config[:new_secret] ? 2 : 1 }
    @i18n.my_filter.should == 1

    R18n::Filters.add('my', :second, :position => 0) do |content, config|
      config[:new_secret] = true
      content
    end
    @i18n.my_filter.should == 2
  end

  it "sends parameters to filter" do
    R18n::Filters.add('my') { |i, config, a, b| "#{i}#{a}#{b}" }
    @i18n['my_filter', 1, 2].should == 'value12'
    @i18n.my_filter(1, 2).should == 'value12'
  end

  it "calls proc from translation" do
    @i18n.sum(2, 3).should == 5
  end

  it "pluralizes translation" do
    @i18n.comments(0, 'article').should == 'no comments for article'
    @i18n.comments(1, 'article').should == 'one comment for article'
    @i18n.comments(5, 'article').should == '5 comments for article'

    @i18n.files(0).should    == '0 files'
    @i18n.files(-5.5).should == '−5.5 files'
    @i18n.files(5000).should == '5,000 files'
  end

  it "doesn't pluralize without first numeric parameter" do
    @i18n.files.should       be_a(R18n::UnpluralizetedTranslation)
    @i18n.files('').should   be_a(R18n::UnpluralizetedTranslation)
    @i18n.files[1].should    == '1 file'
    @i18n.files.n(5).should  == '5 files'
  end

  it "converts first float parameter to number" do
    @i18n.files(1.2).should == '1 file'
  end

  it "pluralizes translation without locale" do
    i18n = R18n::I18n.new('nolocale', DIR)
    i18n.entries(1).should == 'ONE'
    i18n.entries(5).should == 'N'
  end

  it "cans use params in translation" do
    @i18n.params(-1, 2).should == 'Is −1 between −1 and 2?'
  end

  it "substitutes '%2' as param but not value of second param" do
    @i18n.params('%2 FIRST', 'SECOND').should ==
      'Is %2 FIRST between %2 FIRST and SECOND?'
  end

  it "formats untranslated" do
    @i18n.in.not.to_s.should   == 'in.[not]'
    @i18n.in.not.to_str.should == 'in.[not]'

    R18n::Filters.off(:untranslated)
    @i18n.in.not.to_s.should == 'in.not'

    R18n::Filters.add(R18n::Untranslated) do |v, c, trans, untrans, path|
      "#{path} #{trans}[#{untrans}]"
    end
    @i18n.in.not.to_s.should == 'in.not in.[not]'
  end

  it "formats translation path" do
    @i18n.in.another.to_s.should == 'in.another[]'

    R18n::Filters.off(:untranslated)
    @i18n.in.another.to_s.should == 'in.another'

    R18n::Filters.add(R18n::Untranslated) do |v, c, trans, untrans, path|
      "#{path} #{trans}[#{untrans}]"
    end
    @i18n.in.another.to_s.should == 'in.another in.another[]'
  end

  it "formats untranslated for web" do
    R18n::Filters.off(:untranslated)
    R18n::Filters.on(:untranslated_html)
    @i18n.in.not.to_s.should == 'in.<span style="color: red">[not]</span>'
    @i18n['<b>'].to_s.should == '<span style="color: red">[&lt;b&gt;]</span>'
  end

  it "allows to set custom filters" do
    R18n::Filters.add(R18n::Untranslated, :a) { |v, c| "a #{v}" }
    R18n::Filters.off(:a)

    html = R18n::I18n.new('en', DIR, :off_filters => :untranslated,
                                     :on_filters  => [:untranslated_html, :a])
    html.in.not.to_s.should == 'a in.<span style="color: red">[not]</span>'
  end

  it "has filter for escape HTML" do
    @i18n.html.should == '&lt;script&gt;true &amp;&amp; false&lt;/script&gt;'
  end

  it "has disabled global filter for escape HTML" do
    @i18n.greater('true').should == '1 < 2 is true'

    R18n::Filters.on(:global_escape_html)
    @i18n.reload!
    @i18n.greater('true').should == '1 &lt; 2 is true'
    @i18n.html.should == '&lt;script&gt;true &amp;&amp; false&lt;/script&gt;'
  end

  it "has filter to disable global HTML escape" do
    @i18n.no_escape.should == '<b>Warning</b>'

    R18n::Filters.on(:global_escape_html)
    @i18n.reload!
    @i18n.no_escape.should == '<b>Warning</b>'
  end

  it "has Markdown filter" do
    @i18n.markdown.simple.should == "<p><strong>Hi!</strong></p>\n"
  end

  it "has Textile filter" do
    @i18n.textile.simple.should == '<p><em>Hi!</em></p>'
  end

  it "HTML escapes before Markdown and Textile filters" do
    @i18n.markdown.html.should == "<p><strong>Hi!</strong> <br /></p>\n"
    @i18n.textile.html.should  == '<p><em>Hi!</em><br /></p>'

    R18n::Filters.on(:global_escape_html)
    @i18n.reload!
    @i18n.markdown.html.should == "<p><strong>Hi!</strong> &lt;br /&gt;</p>\n"
    @i18n.textile.html.should  == '<p><em>Hi!</em>&lt;br /&gt;</p>'
  end

  it "allows to listen filters adding" do
    R18n::Filters.listen {
      R18n::Filters.add(String, :a) { }
    }.should == [R18n::Filters.defined[:a]]
  end

  it "escapes variables if ActiveSupport is loaded" do
    @i18n.escape_params('<br>').should == '<b><br></b>'
    require 'active_support'
    @i18n.escape_params('<br>').should == '<b>&lt;br&gt;</b>'
  end

  it "uses SafeBuffer if it is loaded" do
    require 'active_support'

    R18n::Filters.on(:global_escape_html)
    @i18n.reload!

    @i18n.greater('<b>'.html_safe).should == '1 &lt; 2 is <b>'
  end

end
