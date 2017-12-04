require File.join(File.dirname(__FILE__), 'en')

module R18n::Locales
  class EnGb < En
    set title: 'British English',
        sublocales: %w{en},

        date_format: '%d/%m/%Y'
  end
end
