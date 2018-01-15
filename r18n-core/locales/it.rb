# frozen_string_literal: true

module R18n
  module Locales
    # Italian locale
    class It < Locale
      set(
        title: 'Italiano',

        wday_names: %w[domenica lunedì martedì mercoledì giovedì venerdì
                       sabato],
        wday_abbrs: %w[dom lun mar mer gio ven sab],

        month_names: %w[gennaio febbraio marzo aprile maggio giugno
                        luglio agosto settembre ottobre novembre dicembre],
        month_abbrs: %w[gen feb mar apr mag giu lug ago set ott nov dic],

        date_format: '%d/%m/%Y',

        number_decimal: ',',
        number_group:   ' '
      )

      def format_date_full(date, year = true, *_params)
        full = super(date, year)
        if full[0..1] == ' 1'
          '1º' + full[2..-1]
        else
          full
        end
      end
    end
  end
end
