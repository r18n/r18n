# frozen_string_literal: true

describe TestController, type: :controller do
  render_views

  it 'uses default locale' do
    get :locales
    expect(response).to have_http_status(200)
    expect(response.body).to eq 'ru'
  end

  it 'gets locale from param' do
    get :locales, params: { locale: 'ru' }
    expect(response).to have_http_status(200)
    expect(response.body).to eq 'ru'
  end

  it 'gets locale from session' do
    get :locales, session: { locale: 'ru' }
    expect(response).to have_http_status(200)
    expect(response.body).to eq 'ru'
  end

  describe 'locales from http' do
    it 'gets from regular locales' do
      request.env['HTTP_ACCEPT_LANGUAGE'] = 'ru,fr;q=0.9'
      get :locales
      expect(response).to have_http_status(200)
      expect(response.body).to eq 'ru, fr'
    end

    it 'gets from wildcard' do
      request.env['HTTP_ACCEPT_LANGUAGE'] = '*'
      get :locales
      expect(response).to have_http_status(200)
      expect(response.body).to eq 'ru'
    end

    it 'gets from regular locales with wildcard' do
      request.env['HTTP_ACCEPT_LANGUAGE'] = 'ru, fr;q=0.9, *;q=0.5'
      get :locales
      expect(response).to have_http_status(200)
      expect(response.body).to eq 'ru, fr'
    end
  end

  it 'loads translations' do
    get :translations, params: { locale: 'en' }
    expect(response).to have_http_status(200)
    expect(response.body).to eq 'R18n: supported. Rails I18n: supported'
  end

  it 'returns available translations' do
    get :available
    expect(response).to have_http_status(200)
    expect(response.body).to eq 'en ru'
  end

  it 'adds helpers' do
    get :helpers, params: { locale: 'en' }
    expect(response).to have_http_status(200)
    expect(response.body).to eq "Name\nName\nName\nName\n"
  end

  it 'formats untranslated' do
    get :untranslated
    expect(response).to have_http_status(200)
    expect(response.body).to eq(
      'user.<span style="color: red">[not.exists]</span>'
    )
  end

  it 'adds methods to controller' do
    get :controller, params: { locale: 'en' }
    expect(response).to have_http_status(200)
    expect(response.body).to eq 'Name Name Name'
  end

  it 'localizes time by Rails I18n' do
    get :time, params: { locale: 'en' }
    expect(response).to have_http_status(200)
    expect(response.body).to eq "Thu, 01 Jan 1970 00:00:00 +0000\n01 Jan 00:00"
  end

  it 'localizes time by R18n' do
    get :human_time, params: { locale: 'en' }
    expect(response).to have_http_status(200)
    expect(response.body).to eq 'now'
  end

  it 'translates models' do
    ActiveRecord::Schema.verbose = false
    ActiveRecord::Schema.define(version: 20_091_218_130_034) do
      create_table 'posts', force: true do |t|
        t.string 'title_en'
        t.string 'title_ru'
      end
    end

    expect(Post.unlocalized_getters(:title)).to eq(
      'ru' => 'title_ru',
      'en' => 'title_en'
    )
    expect(Post.unlocalized_setters(:title)).to eq(
      'ru' => 'title_ru=',
      'en' => 'title_en='
    )

    # Default locale is `ru`

    @post = Post.new
    @post.title_ru = 'Запись'

    R18n.set('en')
    expect(@post.title).to eq 'Запись'

    @post.title = 'Record'
    expect(@post.title_ru).to eq 'Запись'
    expect(@post.title_en).to eq 'Record'
    expect(@post.title).to eq 'Record'
  end

  it 'sets default places' do
    expect(R18n.default_places).to eq([
      Rails.root.join('app/i18n'), R18n::Loader::Rails.new
    ])

    R18n.set('en')
    expect(R18n.get.user.name).to eq 'Name'
  end

  it 'translates mails' do
    ::I18n.locale = 'en'
    email = TestMailer.test.deliver_now
    expect(email.body.to_s).to eq "Name\nName\nName\n"
  end

  it 'reloads filters from app directory' do
    get :filter, params: { locale: 'en' }
    expect(response).to have_http_status(200)
    expect(response.body).to eq 'Rails'
    expect(R18n::Rails::Filters.loaded).to eq [:rails_custom_filter]

    R18n::Filters.defined[:rails_custom_filter].block = proc { 'No' }
    get :filter, params: { locale: 'en' }

    expect(response).to have_http_status(200)
    expect(response.body).to eq 'Rails'
  end

  it 'escapes html inside R18n' do
    get :safe, params: { locale: 'en' }
    expect(response).to have_http_status(200)
    expect(response.body).to eq(
      "<b> user.<span style=\"color: red\">[no_tr]</span>\n"
    )
  end

  it 'works with Rails build-in herlpers' do
    get :format
    expect(response).to have_http_status(200)
    expect(response.body).to eq "1 000,1 руб.\n"
  end

  it 'caches I18n object' do
    R18n.clear_cache!

    get :translations
    expect(R18n.cache.keys.length).to eq 1

    get :translations
    expect(R18n.cache.keys.length).to eq 1

    get :translations
    request.env['HTTP_ACCEPT_LANGUAGE'] = 'ru,fr;q=0.9'
    expect(R18n.cache.keys.length).to eq 1

    get :translations, params: { locale: 'en' }
    expect(R18n.cache.keys.length).to eq 2
  end

  it 'parameterizes strigns' do
    expect('One two три'.parameterize).to eq 'one-two'
  end
end
