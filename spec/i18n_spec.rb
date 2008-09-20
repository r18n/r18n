require File.join(File.dirname(__FILE__), 'spec_helper')

describe R18n::I18n do

  it "should parse HTTP_ACCEPT_LANGUAGE" do
    R18n::I18n.parse_http_accept_language(nil).should == []
    R18n::I18n.parse_http_accept_language('').should == []
    R18n::I18n.parse_http_accept_language('ru,en;q=0.9').should == ['ru', 'en']
    R18n::I18n.parse_http_accept_language('ru;q=0.8,en;q=0.9').should == ['en', 'ru']
  end

  it "should has default locale" do
    R18n::I18n.default = 'ru'
    R18n::I18n.default.should == 'ru'
  end

end
