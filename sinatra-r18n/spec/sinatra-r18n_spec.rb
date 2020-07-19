# frozen_string_literal: true

describe Sinatra::R18n do
  before(:all) do
    Sinatra::R18n.registered(app)
  end

  after do
    app.set :default_locale, 'en'
    app.set :environment, :test
    ::R18n.thread_set nil
  end

  it 'translates messages' do
    get '/en/posts/1'
    expect(last_response).to be_ok
    expect(last_response.body).to eq "<h1>Post 1</h1>\n"
  end

  it 'uses translations from default locale' do
    get '/ru/posts/1/comments'
    expect(last_response).to be_ok
    expect(last_response.body).to eq '3 comments'
  end

  it 'uses default locale' do
    app.set :default_locale, 'ru'
    get '/locale'
    expect(last_response).to be_ok
    expect(last_response.body).to eq 'Русский'
  end

  describe 'autodetect user locale' do
    it 'works with regular' do
      get '/locale', {}, 'HTTP_ACCEPT_LANGUAGE' => 'ru,en;q=0.9'
      expect(last_response).to be_ok
      expect(last_response.body).to eq 'Русский'
    end

    it 'works with only wildcard' do
      get '/locale', {}, 'HTTP_ACCEPT_LANGUAGE' => '*'
      expect(last_response).to be_ok
      expect(last_response.body).to eq 'English'
    end

    it 'works with only regular and wildcard' do
      get '/locale', {}, 'HTTP_ACCEPT_LANGUAGE' => 'ru, en;q=0.9, *;q=0.5'
      expect(last_response).to be_ok
      expect(last_response.body).to eq 'Русский'
    end
  end

  it 'uses locale from param' do
    get '/locale', locale: 'ru'
    expect(last_response).to be_ok
    expect(last_response.body).to eq 'Русский'
  end

  it 'ignore empty param' do
    get '/locale', locale: ''
    expect(last_response).to be_ok
    expect(last_response.body).to eq 'English'
  end

  it 'uses locale from session' do
    get '/locale', {}, 'rack.session' => { locale: 'ru' }
    expect(last_response).to be_ok
    expect(last_response.body).to eq 'Русский'
  end

  it 'ignore empty session' do
    get '/locale', {}, 'rack.session' => { locale: '' }
    expect(last_response).to be_ok
    expect(last_response.body).to eq 'English'
  end

  it 'ignores empty locale' do
    get '/locale', {}
    expect(last_response).to be_ok
    expect(last_response.body).to eq 'English'
  end

  it 'returns locales list' do
    get '/locales'
    expect(last_response).to be_ok
    expect(last_response.body).to eq 'en: English; ru: Русский'
  end

  it 'formats untranslated string' do
    get '/untranslated'
    expect(last_response).to be_ok
    expect(last_response.body).to eq 'post.<span style="color: red">[no]</span>'
  end

  it 'localizes objects' do
    get '/time'
    expect(last_response).to be_ok
    expect(last_response.body).to eq '1970-01-01 00:00'
  end

  it 'sets default places' do
    path = File.join(__dir__, 'app', 'i18n')
    expect(R18n.default_places).to eq path
    R18n.set('en')
    expect(R18n.get.post.title(1)).to eq 'Post 1'
  end
end
