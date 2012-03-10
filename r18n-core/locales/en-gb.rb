require File.join(File.dirname(__FILE__), 'en')

module R18n::Locales
  class EnGb < En
    set :title => 'British English',
        :code  => 'en-GB',
        :sublocales => %w{en}
  end
end
