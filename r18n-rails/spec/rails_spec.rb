require File.join(File.dirname(__FILE__), 'spec_helper')

describe 'R18n for Rails', :type => :controller do
  controller_name :test
  integrate_views
  
  it 'should use default locale' do
    get :locales
    response.should be_success
    response.body.should == 'en'
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
    get :translations
    response.should be_success
    response.body.should == 'R18n: supported. Rails I18n: supported'
  end
  
  it 'should return available translations' do
    get :available
    response.should be_success
    response.body.should == 'ru, en'
  end
  
  it 'should add helpers' do
    get :helpers
    response.should be_success
    response.body.should == "Name\nName\nName\nName\n"
  end
  
  it 'should format untranslated' do
    get :untranslated
    response.should be_success
    response.body.should == "user.<span style='color: red'>not.exists</span>"
  end
  
end
