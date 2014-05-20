# encoding: utf-8
require File.expand_path('../spec_helper', __FILE__)

describe Sinatra::R18n do
  before(:all) do
    Sinatra::R18n.registered(app)
  end

  after do
    app.set :default_locale, 'en'
    app.set :environment, :test
  end

  it "translates messages" do
    get '/en/posts/1'
    expect(last_response).to be_ok
    expect(last_response.body).to eq "<h1>Post 1</h1>\n"
  end

  it "uses translations from default locale" do
    get '/ru/posts/1/comments'
    expect(last_response).to be_ok
    expect(last_response.body).to eq '3 comments'
  end

  it "uses default locale" do
    app.set :default_locale, 'ru'
    get '/locale'
    expect(last_response).to be_ok
    expect(last_response.body).to eq 'Русский'
  end

  it "autodetects user locale" do
    get '/locale', {}, {'HTTP_ACCEPT_LANGUAGE' => 'ru,en;q=0.9'}
    expect(last_response).to be_ok
    expect(last_response.body).to eq 'Русский'
  end

  it "uses locale from session" do
    get '/locale', { }, { 'rack.session' => { :locale => 'ru' } }
    expect(last_response).to be_ok
    expect(last_response.body).to eq 'Русский'
  end

  it "returns locales list" do
    get '/locales'
    expect(last_response).to be_ok
    expect(last_response.body).to eq 'en: English; ru: Русский'
  end

  it "formats untranslated string" do
    get '/untranslated'
    expect(last_response).to be_ok
    expect(last_response.body).to eq 'post.<span style="color: red">[no]</span>'
  end

  it "localizes objects" do
    get '/time'
    expect(last_response).to be_ok
    expect(last_response.body).to eq "01/01/1970 00:00"
  end

  it "sets default places" do
    expect(R18n.default_places).to eq Pathname(__FILE__).dirname.expand_path.join('app/i18n/').to_s
    R18n.set('en')
    expect(R18n.get.post.title(1)).to eq 'Post 1'
  end
end
