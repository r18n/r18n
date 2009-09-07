# encoding: utf-8
require File.join(File.dirname(__FILE__), 'spec_helper')
require File.join(File.dirname(__FILE__), '..', 'lib', 'r18n-core', 'translated')

describe R18n::Translated do
  before do
    @user_class = Class.new do
      include R18n::Translated
      attr_accessor :name_ru, :name_en
    end
    R18n.set(R18n::I18n.new('en'))
  end
  
  it "should save methods map" do
    @user_class.translation :name, :methods => { :ru => :name_ru }
    @user_class.unlocalized_getters(:name).should == { 'ru' => 'name_ru' }
    @user_class.unlocalized_setters(:name).should == { 'ru' => 'name_ru=' }
  end
  
  it "should autodetect methods map" do
    @user_class.translation :name
    @user_class.unlocalized_getters(:name).should == {
        'en' => 'name_en', 'ru' => 'name_ru' }
    @user_class.unlocalized_setters(:name).should == {
        'en' => 'name_en=', 'ru' => 'name_ru=' }
  end
  
  it "should translate methods" do
    @user_class.translation :name
    user = @user_class.new
    
    user.name.should be_nil
    user.name = 'John'
    user.name.should == 'John'
    
    R18n.set(R18n::I18n.new('ru'))
    user.name.should == 'John'
    user.name = 'Джон'
    user.name.should == 'Джон'
  end
  
  it "should return TranslatedString" do
    class ::SomeTranslatedClass
      include R18n::Translated
      def name_en; 'John'; end
      translation :name
    end
    obj = ::SomeTranslatedClass.new
    
    obj.name.should be_a(R18n::TranslatedString)
    obj.name.locale.should == R18n::Locale.load('en')
    obj.name.path.should == 'SomeTranslatedClass#name'
  end
  
  it "should search translation by locales priority" do
    @user_class.translation :name
    user = @user_class.new
    
    R18n.set(R18n::I18n.new(['no_LC', 'ru', 'en']))
    user.name_ru = 'Иван'
    user.name.locale.should == R18n::Locale.load('ru')
  end
  
  it "should use default locale" do
    @user_class.translation :name
    user = @user_class.new
    
    R18n.set(R18n::I18n.new('no_LC'))
    user.name_en = 'John'
    user.name.locale.should == R18n::Locale.load('en')
  end
  
  it "should use filters" do
    @user_class.class_eval do
      def age_en; {1 => '%1 year', 'n' => '%1 years'} end
      translation :age, :type => 'pl', :no_params => true
    end
    user = @user_class.new
    
    user.age(20).should == '20 years'
  end
  
  it "should send params to method if user want it" do
    @user_class.class_eval do
      def no_params_en(*params) params.join(' '); end
      def params_en(*params)    params.join(' '); end
      translations [:no_params, {:no_params => true}], :params
    end
    user = @user_class.new
    
    user.no_params(1, 2).should == ''
    user.params(1, 2).should == '1 2'
  end
  
  it "should return Untranslated when can't find translation" do
    class ::SomeUntranslatedClass
      include R18n::Translated
      
      translation :no
    end
    obj = ::SomeUntranslatedClass.new
    
    obj.no.should be_a(R18n::Untranslated)
    obj.no.translated_path.should == 'SomeUntranslatedClass#'
    obj.no.untranslated_path.should == 'no'
  end
  
end
