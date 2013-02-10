# encoding: utf-8
require File.expand_path('../spec_helper', __FILE__)

describe TestController, :type => :controller do
  render_views

  it 'should use default locale' do
    get :locales
    response.should be_success
    response.body.should == 'ru'
  end

  it 'should get locale from param' do
    get :locales, :locale => 'ru'
    response.should be_success
    response.body.should == 'ru, en'
  end

  it 'should get locale from session' do
    get :locales, {}, { :locale => 'ru' }
    response.should be_success
    response.body.should == 'ru, en'
  end

  it 'should get locales from http' do
    request.env['HTTP_ACCEPT_LANGUAGE'] = 'ru,fr;q=0.9'
    get :locales
    response.should be_success
    response.body.should == 'ru, fr, en'
  end

  it 'should load translations' do
    get :translations, :locale => 'en'
    response.should be_success
    response.body.should == 'R18n: supported. Rails I18n: supported'
  end

  it 'should return available translations' do
    get :available
    response.should be_success
    response.body.should == 'en ru'
  end

  it 'should add helpers' do
    get :helpers, :locale => 'en'
    response.should be_success
    response.body.should == "Name\nName\nName\nName\n"
  end

  it 'should format untranslated' do
    get :untranslated
    response.should be_success
    response.body.should == 'user.<span style="color: red">[not.exists]</span>'
  end

  it "should add methods to controller" do
    get :controller, :locale => 'en'
    response.should be_success
    response.body.should == "Name Name Name"
  end

  it "should localize time by Rails I18n" do
    get :time, :locale => 'en'
    response.should be_success
    response.body.should == "Thu, 01 Jan 1970 00:00:00 +0000\n01 Jan 00:00"
  end

  it "should localize time by R18n" do
    get :human_time, :locale => 'en'
    response.should be_success
    response.body.should == "now"
  end

  it "should translate models" do
    ActiveRecord::Schema.verbose = false
    ActiveRecord::Schema.define(:version => 20091218130034) do
      create_table "posts", :force => true do |t|
        t.string "title_en"
        t.string "title_ru"
      end
    end

    Post.unlocalized_getters(:title).should == { 'ru' => 'title_ru',
                                                 'en' => 'title_en' }
    Post.unlocalized_setters(:title).should == { 'ru' => 'title_ru=',
                                                 'en' => 'title_en=' }

    @post = Post.new
    @post.title_en = 'Record'

    R18n.set('ru')
    @post.title.should == 'Record'

    @post.title = 'Запись'
    @post.title_ru.should == 'Запись'
    @post.title_en.should == 'Record'
    @post.title.should    == 'Запись'
  end

  it "should set default places" do
    R18n.default_places.should == [Rails.root.join('app/i18n'),
                                   R18n::Loader::Rails.new]
    R18n.set('en')
    R18n.get.user.name.should == 'Name'
  end

  it "should translate mails" do
    email = TestMailer.test.deliver
    email.encoded.should =~ /Name\r\nName\r\nName\r\n$/
  end

  it "should reload filters from app directory" do
    get :filter, :locale => 'en'
    response.should be_success
    response.body.should == 'Rails'
    R18n::Rails::Filters.loaded.should == [:rails_custom_filter]

    R18n::Filters.defined[:rails_custom_filter].block = proc { 'No' }
    get :filter, :locale => 'en'

    response.should be_success
    response.body.should == 'Rails'
  end

  it "should escape html inside R18n" do
    get :safe, :locale => 'en'
    response.should be_success
    response.body.should ==
      "<b> user.<span style=\"color: red\">[no_tr]</span>\n"
  end


  it "should work with Rails build-in herlpers" do
    get :format
    response.should be_success
    response.body.should == "1 000,1 руб.\n"
  end

  it "should cache I18n object" do
    R18n.clear_cache!

    get :translations
    R18n.cache.keys.length.should == 1

    get :translations
    R18n.cache.keys.length.should == 1

    get :translations
    request.env['HTTP_ACCEPT_LANGUAGE'] = 'ru,fr;q=0.9'
    R18n.cache.keys.length.should == 1

    get :translations, :locale => 'en'
    R18n.cache.keys.length.should == 2
  end

end
