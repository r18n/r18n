require File.join(File.dirname(__FILE__), 'spec_helper')

describe 'Rails filters' do
  before :all do
    @en = R18n::Locale.load('en')
  end
  
  it "should use named variables" do
    i18n = R18n::Translation.new([@en], [{ 'echo' => 'Value is {{value}}' }])
    i18n.echo(:value => 'R18n').should == 'Value is R18n'
    i18n.echo(:value => -5.5).should == 'Value is −5.5'
    i18n.echo(:value => 5000).should == 'Value is 5,000'
    i18n.echo.should == 'Value is {{value}}'
  end
  
end
