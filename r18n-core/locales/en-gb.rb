require File.join(File.dirname(__FILE__), 'en')

module R18n::Locales
  class EnGb < En
    set :title => 'British English',
        :sublocales => %w{en}
  end
end
