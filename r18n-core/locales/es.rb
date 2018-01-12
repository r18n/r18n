# frozen_string_literal: true

module R18n
  module Locales
    # Spanish locale
    class Es < Locale
      set(
        title: 'Español',

        wday_names: %w[domingo lunes martes miércoles jueves viernes sábado],
        wday_abbrs: %w[dom lun mar mie jue vie sab],

        month_names: %w[Enero Febrero Marzo Abril Mayo Junio Julio Agosto
                        Septiembre Octubre Noviembre Diciembre],
        month_abbrs: %w[ene feb mar abr may jun jul ago sep oct nov dic],

        date_format: '%d/%m/%Y',
        full_format: '%d de %B',
        year_format: '_ de %Y',

        number_decimal: ',',
        number_group:   '.'
      )
    end
  end
end
