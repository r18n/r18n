# encoding: utf-8
require File.expand_path('../spec_helper', __FILE__)

describe R18n::Translated do
  before do
    @user_class = Class.new do
      include R18n::Translated
      attr_accessor :name_ru, :name_en

      def name_ru?; end
      def name_ru!; end
    end
    R18n.set('en')
  end

  it "saves methods map" do
    @user_class.translation :name, :methods => { :ru => :name_ru }
    @user_class.unlocalized_getters(:name).should == { 'ru' => 'name_ru' }
    @user_class.unlocalized_setters(:name).should == { 'ru' => 'name_ru=' }
  end

  it "autodetects methods map" do
    @user_class.translation :name
    @user_class.unlocalized_getters(:name).should == {
        'en' => 'name_en', 'ru' => 'name_ru' }
    @user_class.unlocalized_setters(:name).should == {
        'en' => 'name_en=', 'ru' => 'name_ru=' }
  end

  it "translates methods" do
    @user_class.translation :name
    user = @user_class.new

    user.name = 'John'
    user.name.should == 'John'

    R18n.set('ru')
    user.name.should == 'John'
    user.name = 'Джон'
    user.name.should == 'Джон'
  end

  it "returns TranslatedString" do
    class ::SomeTranslatedClass
      include R18n::Translated
      def name_en; 'John'; end
      translation :name
    end
    obj = ::SomeTranslatedClass.new

    obj.name.should be_a(R18n::TranslatedString)
    obj.name.locale.should == R18n.locale('en')
    obj.name.path.should == 'SomeTranslatedClass#name'
  end

  it "searchs translation by locales priority" do
    @user_class.translation :name
    user = @user_class.new

    R18n.set(['nolocale', 'ru', 'en'])
    user.name_ru = 'Иван'
    user.name.locale.should == R18n.locale('ru')
  end

  it "uses default locale" do
    @user_class.translation :name
    user = @user_class.new

    R18n.set('nolocale')
    user.name_en = 'John'
    user.name.locale.should == R18n.locale('en')
  end

  it "uses filters" do
    @user_class.class_eval do
      def age_en; {1 => '%1 year', 'n' => '%1 years'} end
      translation :age, :type => 'pl', :no_params => true
    end
    user = @user_class.new

    user.age(20).should == '20 years'
  end

  it "sends params to method if user want it" do
    @user_class.class_eval do
      def no_params_en(*params) params.join(' '); end
      def params_en(*params)    params.join(' '); end
      translations [:no_params, {:no_params => true}], :params
    end
    user = @user_class.new

    user.no_params(1, 2).should == ''
    user.params(1, 2).should == '1 2'
  end

  it "translates virtual methods" do
    @virtual_class = Class.new do
      include R18n::Translated
      translation :no_method, :methods => { :en => :no_method_en }
      def method_missing(name, *params)
        name.to_s
      end
    end
    virtual = @virtual_class.new

    virtual.no_method.should == 'no_method_en'
  end

  it "returns original type of result" do
    @user_class.class_eval do
      translation :name
      def name_en
        :ivan
      end
    end
    user = @user_class.new

    user.name.should == :ivan
  end

  it "returns nil" do
    @user_class.class_eval do
      translation :name
      def name_en
        nil
      end
    end
    user = @user_class.new

    user.name.should be_nil
  end

  it "allows to change I18n object" do
    @user_class.class_eval do
      translation :name
      attr_accessor :r18n
    end
    user = @user_class.new
    user.name_ru = 'Иван'
    user.name_en = 'John'

    user.r18n = R18n::I18n.new('ru')
    user.name.should == 'Иван'
    user.r18n = R18n::I18n.new('en')
    user.name.should == 'John'
  end

end
