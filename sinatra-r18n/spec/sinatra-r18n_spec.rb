# encoding: utf-8
require File.join(File.dirname(__FILE__), 'spec_helper')

describe Sinatra::R18n do
  
  it "should translate messages" do
    get '/ru/posts/1'
    response.should be_ok
    response.body.should == "<h1>Запись 1</h1>\n"
  end
  
  it "should use translations from default locale" do
    get '/ru/posts/1/comments'
    response.should be_ok
    response.body.should == '3 comments'
  end
  
  it "should use default locale" do
    set :default_locale, 'ru'
    get '/locale'
    response.should be_ok
    response.body.should == 'Русский'
  end
  
  it "should autodetect user locale" do
    get '/locale', :env => {'HTTP_ACCEPT_LANGUAGE' => 'ru,en;q=0.9'}
    response.should be_ok
    response.body.should == 'Русский'
  end
  
  it "should use locale from session" do
    get '/locale', :env => { 'rack.session' => { :locale => 'ru' } }
    response.should be_ok
    response.body.should == 'Русский'
  end
  
  it "should return locales list" do
    get '/locales'
    response.should be_ok
    response.body.should == 'ru: Русский; en: English'
  end
  
end
