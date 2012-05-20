# encoding: utf-8
require File.expand_path('../spec_helper', __FILE__)

describe Sinatra::R18n do
  before(:all) do
    Sinatra::R18n.registered(app)
 	end

  after do
    set :default_locale, 'en'
    set :environment, :test
  end

  it "should translate messages" do
    get '/en/posts/1'
    last_response.should be_ok
    last_response.body.should == "<h1>Post 1</h1>\n"
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

  it "should format untranslated string" do
    get '/untranslated'
    last_response.should be_ok
    last_response.body.should == 'post.<span style="color: red">[no]</span>'
  end

  it "should localize objects" do
    get '/time'
    last_response.should be_ok
    last_response.body.should == "01/01/1970 00:00"
  end

  it "should set default places" do
    R18n.default_places.should ==
      Pathname(__FILE__).dirname.expand_path.join('app/i18n/').to_s
    R18n.set('en')
    R18n.get.post.title(1).should == 'Post 1'
  end

end
