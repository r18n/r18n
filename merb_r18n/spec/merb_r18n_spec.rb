# encoding: utf-8
require File.dirname(__FILE__) + '/spec_helper'

describe "merb_r18n" do

  it "should provide i18n support in merb controller" do
    c = dispatch_to(I18n, :index, {}, "HTTP_ACCEPT_LANGUAGE" => "ru_RU")
    
    c.body.should == "<h1>Article 10 000</h1>\n" +
                     "<p>Написана 01.01.1970</p>\n" +
                     "<p>Переводы: Русский, English</p>\n"
  end
  
  it "should set locale manually" do
    c = dispatch_to(I18n, :code, {}, "HTTP_ACCEPT_LANGUAGE" => "ru")
    c.body.should == "ru\n"
    
    c = dispatch_to(I18n, :code, {:locale => "en"}, "HTTP_ACCEPT_LANGUAGE" => "ru")
    c.body.should == "en\n"
  end
  
  it "should provide i18n support in slice controller" do
    dispatch_to(Slice::Main, :index).body.should == 'SLICE and APP'
  end

end
