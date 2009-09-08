# encoding: utf-8
require File.join(File.dirname(__FILE__), 'spec_helper')

describe Sinatra::R18n do
  after do
    set :default_locale, 'en'
  end
  
  it "should translate messages" do
    get '/ru/posts/1'
    last_response.should be_ok
    last_response.body.should == "<h1>Запись 1</h1>\n"
  end
  
  it "should use translations from default locale" do
    get '/ru/posts/1/comments'
    last_response.should be_ok
    last_response.body.should == '3 comments'
  end
  
  it "should use default locale" do
    set :default_locale, 'ru'
    get '/locale'
    last_response.should be_ok
    last_response.body.should == 'Русский'
  end
  
  it "should autodetect user locale" do
    get '/locale', {}, {'HTTP_ACCEPT_LANGUAGE' => 'ru,en;q=0.9'}
    last_response.should be_ok
    last_response.body.should == 'Русский'
  end
  
  it "should use locale from session" do
    get '/locale', {}, { 'rack.session' => { :locale => 'ru' } }
    last_response.should be_ok
    last_response.body.should == 'Русский'
  end
  
  it "should return locales list" do
    get '/locales'
    last_response.should be_ok
    last_response.body.should == 'en: English; ru: Русский'
  end
  
end
