# frozen_string_literal: true

module R18n
  module Locales
    # Galician locale
    class Gl < Locale
      set(
        title: 'Galego',
        sublocales: %w[es en],

        wday_names: %w[domingo luns martes mércores xoves venres sábado],
        wday_abbrs: %w[dom lun mar mér xov ven sáb],

        month_names: %w[xaneiro febreiro marzo abril maio xuño xullo
                        agosto setembro outubro novembro decembro],
        month_abbrs: %w[xan feb mar abr mai xuñ xul ago set out nov dec],

        date_format: '%d/%m/%Y',
        full_format: '%d de %B',
        year_format: '_ de %Y',

        number_decimal: ',',
        number_group:   '.'
      )
    end
  end
end
