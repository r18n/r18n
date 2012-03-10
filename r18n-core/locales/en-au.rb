require File.join(File.dirname(__FILE__), 'en')

module R18n::Locales
  class EnAu < En
    set :title => 'Australian English',
        :sublocales => %w{en}
  end
end
