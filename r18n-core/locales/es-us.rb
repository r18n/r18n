require File.join(File.dirname(__FILE__), 'es')

module R18n::Locales
  class EsUs < Es
    set title: 'Español Estadounidense',
        sublocales: %w{es en},

        time_format: ' %I:%M %p',
        date_format: '%m/%d/%Y',

        number_decimal: '.',
        number_group:   ','
  end
end
