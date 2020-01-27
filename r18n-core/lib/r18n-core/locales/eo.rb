# frozen_string_literal: true

module R18n
  module Locales
    # Esperanto locale
    class Eo < Locale
      set(
        title: 'Esperanto',

        wday_names: %w[dimanĉo lundo mardo merkredo ĵaŭdo vendredo sabato],
        wday_abbrs: %w[dim lun mar mer ĵaŭ ven sab],

        month_names: %w[
          januaro februaro marto aprilo majo junio julio aŭgusto septembro
          oktobro novembro decembro
        ],
        month_abbrs: %w[jan feb mar apr maj jun jul aŭg sep okt nov dec],

        date_format: '%Y-%m-%d',
        full_format: 'la %-d-a de %B',
        year_format: '_ de %Y',

        number_decimal: '.',
        number_group: ' '
      )
    end
  end
end
