# encoding: utf-8
require File.join(File.dirname(__FILE__), 'spec_helper')

describe R18n::Filters do
  before do
    @system  = R18n::Filters.defined.values
    @enabled = R18n::Filters.defined.values.reject { |i| !i.enabled? }
    @i18n = R18n::I18n.new('en', DIR)
  end
  
  after do
    R18n::Filters.defined.values.each do |filter|
      next if @system.include? filter
      R18n::Filters.delete(filter)
    end
    
    @enabled.each { |i| R18n::Filters.on(i) unless i.enabled? }
    (@system - @enabled).each { |i| R18n::Filters.off(i) if i.enabled? }
  end
  
  it "should add new filter" do
    filter = R18n::Filters.add('my', :my_filter) { |i, config| i }
    
    filter.should be_a(R18n::Filters::Filter)
    filter.name.should == :my_filter
    filter.type.should == 'my'
    filter.should be_enabled
    
    R18n::Filters.defined.should have_key(:my_filter)
    @i18n.my_filter.should == 'value'
    @i18n.my_tree_filter.should == {'name' => 'value'}
  end
  
  it "should use cascade filters" do
    filter = R18n::Filters.add('my', :one)      { |i, config| i + '1' }
    filter = R18n::Filters.add('my', :two)      { |i, config| i + '2' }
    filter = R18n::Filters.add('my', :three, 0) { |i, config| i + '3' }
    @i18n.my_filter.should == 'value312'
  end
  
  it "should return name for nameless filter" do
    R18n::Filters.instance_variable_set(:@last_auto_name, 0)
    
    R18n::Filters.add('some').name.should == 1
    R18n::Filters.add('some').name.should == 2
    
    R18n::Filters.add('some', 3)
    R18n::Filters.add('some').name.should == 4
  end
  
  it "should delete filter by name" do
    R18n::Filters.add('my', :my_filter) { '1' }
    @i18n.my_filter.should == '1'
    
    R18n::Filters.delete(:my_filter)
    R18n::Filters.defined.should_not have_key(:my_filter)
    @i18n.my_filter.should == 'value'
  end
  
  it "should delete filter by object" do
    filter = R18n::Filters.add('my') { '1' }
    @i18n.my_filter.should == '1'
    
    R18n::Filters.delete(filter)
    R18n::Filters.defined.should_not have_key(filter.name)
    @i18n.my_filter.should == 'value'
  end
  
  it "should use global filters" do
    R18n::Filters.add(String) { |result, config, a, b| result + a + b }
    R18n::Filters.add(String) { |result, config| result + '!' }
    
    @i18n.one('1', '2').should == 'One12!'
  end
  
  it "should turn off filter" do
    filter = R18n::Filters.add('my', :one) { |i, config| i + '1' }
    filter = R18n::Filters.add('my', :two) { |i, config| i + '2' }
    
    R18n::Filters.off(:one)
    R18n::Filters.defined[:one].should_not be_enabled
    @i18n.my_filter.should == 'value2'
    
    R18n::Filters.on(:one)
    R18n::Filters.defined[:one].should be_enabled
    @i18n.my_filter.should == 'value12'
  end
  
  it "should send config to filter" do
    R18n::Filters.add('my') do |i, config|
      config.secret_value = 1
      config
    end
    @i18n.my_filter.locale.should == @i18n.locale
    @i18n.my_filter.path.should == 'my_filter'
    @i18n.my_filter.secret_value.should == 1
    @i18n.my_filter.unknown_value.should be_nil
  end
  
  it "should use one config for cascade filters" do
    R18n::Filters.add('my') { |content, config| config.new_secret ? 2 : 1 }
    @i18n.my_filter.should == 1
    
    R18n::Filters.add('my', nil, 0) do |content, config|
      config.new_secret = true
      content
    end
    @i18n.my_filter.should == 2
  end
  
  it "should send parameters to filter" do
    R18n::Filters.add('my') { |i, config, a, b| "#{i}#{a}#{b}" }
    @i18n['my_filter', 1, 2].should == 'value12'
    @i18n.my_filter(1, 2).should == 'value12'
  end

  it "should call proc from translation" do
    @i18n.sum(2, 3).should == 5
  end

  it "should pluralize translation" do
    @i18n.comments(0, 'article').should == 'no comments for article'
    @i18n.comments(1, 'article').should == 'one comment for article'
    @i18n.comments(5, 'article').should == '5 comments for article'
    
    @i18n.files(0).should == '0 files'
    @i18n.files(-5.5).should == '−5.5 files'
    @i18n.files(5000).should == '5,000 files'
  end

  it "should pluralize translation without locale" do
    i18n = R18n::I18n.new('no-LC', DIR)
    i18n.entries(1).should == 'ONE'
    i18n.entries(5).should == 'N'
  end

  it "should can use params in translation" do
    @i18n.params(-1, 2).should == 'Is −1 between −1 and 2?'
  end
  
  it "should can use named params in translations" do
    @i18n.named(:name => 'R18n').should == 'Value is {{value}}'
    R18n::Filters.on(:named_variables)
    @i18n.named(:value => -5.5).should == 'Value is −5.5'
    @i18n.named(:value => 5000).should == 'Value is 5,000'
    @i18n.named.should == 'Value is {{value}}'
  end
  
  it "should format untranslated" do
    @i18n.in.not.to_s.should == 'in.[not]'
    
    R18n::Filters.off(:untranslated)
    @i18n.in.not.to_s.should == 'in.not'
    
    R18n::Filters.add(R18n::Untranslated) do |v, c, trans, untrans, path|
      "#{path} #{trans}[#{untrans}]"
    end
    @i18n.in.not.to_s.should == 'in.not in.[not]'
  end
  
  it "should format translation path" do
    @i18n.in.another.to_s.should == 'in.another[]'
    
    R18n::Filters.off(:untranslated)
    @i18n.in.another.to_s.should == 'in.another'
    
    R18n::Filters.add(R18n::Untranslated) do |v, c, trans, untrans, path|
      "#{path} #{trans}[#{untrans}]"
    end
    @i18n.in.another.to_s.should == 'in.another in.another[]'
  end
  
  it "should have filter for escape HTML" do
    @i18n.html.should == '&lt;script&gt;true &amp;&amp; false&lt;/script&gt;'
  end
  
  it "should have disabled global filter for escape HTML" do
    @i18n.greater.should == '1 < 2 is true'
    
    R18n::Filters.on(:global_escape_html)
    @i18n.greater.should == '1 &lt; 2 is true'
    @i18n.html.should == '&lt;script&gt;true &amp;&amp; false&lt;/script&gt;'
  end
  
  it "should have filter to disable global HTML escape" do
    @i18n.no_escape.should == '<b>Warning</b>'
    R18n::Filters.on(:global_escape_html)
    @i18n.no_escape.should == '<b>Warning</b>'
  end
  
  it "should have Markdown filter" do
    @i18n.markdown.should == '<p><strong>Hi!</strong></p>'
  end
  
  it "should have Textile filter" do
    @i18n.textile.should == '<p><em>Hi!</em></p>'
  end
  
end
