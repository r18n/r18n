require File.join(File.dirname(__FILE__), 'en')

module R18n::Locales
  class EnUs < En
    set title: 'American English',
        sublocales: %w{en},

        time_format: '_ %I:%M %p',
        date_format: '%m/%d/%Y',
        full_format: '%B %e'
  end
end
