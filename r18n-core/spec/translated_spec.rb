# frozen_string_literal: true

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

  it 'saves methods map' do
    @user_class.translation :name, methods: { ru: :name_ru }
    expect(@user_class.unlocalized_getters(:name)).to eq('ru' => 'name_ru')
    expect(@user_class.unlocalized_setters(:name)).to eq('ru' => 'name_ru=')
  end

  it 'autodetects methods map' do
    @user_class.translation :name
    expect(@user_class.unlocalized_getters(:name)).to eq(
      'en' => 'name_en', 'ru' => 'name_ru'
    )
    expect(@user_class.unlocalized_setters(:name)).to eq(
      'en' => 'name_en=', 'ru' => 'name_ru='
    )
  end

  it 'translates methods' do
    @user_class.translation :name
    user = @user_class.new

    user.name = 'John'
    expect(user.name).to eq('John')

    R18n.set('ru')
    expect(user.name).to eq('John')
    user.name = 'Джон'
    expect(user.name).to eq('Джон')
  end

  it 'translates locales with regions' do
    class SomeTranslatedClass
      include R18n::Translated

      def name_en_us
        'John'
      end

      translation :name
    end
    obj = ::SomeTranslatedClass.new

    R18n.set('en-US')
    expect(obj.name).to eq('John')
  end

  it 'returns TranslatedString' do
    class SomeTranslatedClass
      include R18n::Translated

      def name_en
        'John'
      end

      translation :name
    end
    obj = ::SomeTranslatedClass.new

    expect(obj.name).to be_kind_of(R18n::TranslatedString)
    expect(obj.name.locale).to eq(R18n.locale('en'))
    expect(obj.name.path).to eq('SomeTranslatedClass#name')
  end

  it 'searchs translation by locales priority' do
    @user_class.translation :name
    user = @user_class.new

    R18n.set(%w[nolocale ru en])
    user.name_ru = 'Иван'
    expect(user.name.locale).to eq(R18n.locale('ru'))
  end

  it 'uses default locale' do
    @user_class.translation :name
    user = @user_class.new

    R18n.set('nolocale')
    user.name_en = 'John'
    expect(user.name.locale).to eq(R18n.locale('en'))
  end

  it 'uses filters' do
    @user_class.class_exec do
      def age_en
        { 1 => '%1 year', 'n' => '%1 years' }
      end
      translation :age, type: 'pl', no_params: true
    end
    user = @user_class.new

    expect(user.age(20)).to eq('20 years')
  end

  it 'sends params to method if user want it' do
    @user_class.class_exec do
      def no_params_en(*params)
        params.join(' ')
      end

      def params_en(*params)
        params.join(' ')
      end

      translations [:no_params, { no_params: true }], :params
    end
    user = @user_class.new

    expect(user.no_params(1, 2)).to eq('')
    expect(user.params(1, 2)).to eq('1 2')
  end

  it 'translates virtual methods' do
    @virtual_class = Class.new do
      include R18n::Translated

      translation :no_method, methods: { en: :no_method_en }

      def method_missing(name, *_params)
        return name.to_s if name.to_s =~ /^no_method*/
        super
      end

      def respond_to_missing?(name, *_params)
        return true if name.to_s =~ /^no_method*/
        super
      end
    end
    virtual = @virtual_class.new

    expect(virtual.no_method).to eq('no_method_en')
  end

  it 'returns original type of result' do
    @user_class.class_exec do
      translation :name
      def name_en
        :ivan
      end
    end
    user = @user_class.new

    expect(user.name).to eq(:ivan)
  end

  it 'returns nil' do
    @user_class.class_exec do
      translation :name
      def name_en
        nil
      end
    end
    user = @user_class.new

    expect(user.name).to be_nil
  end

  it 'allows to change I18n object' do
    @user_class.class_exec do
      translation :name
      attr_accessor :r18n
    end
    user = @user_class.new
    user.name_ru = 'Иван'
    user.name_en = 'John'

    user.r18n = R18n::I18n.new('ru')
    expect(user.name).to eq('Иван')
    user.r18n = R18n::I18n.new('en')
    expect(user.name).to eq('John')
  end
end
