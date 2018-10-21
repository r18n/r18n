# frozen_string_literal: true

module R18n
  module Locales
    # Latvian locale
    class Lv < Locale
      set(
        title: 'Latviešu',

        week_start: :monday,
        wday_names: %w[Svētdiena Pirmdiena Otrdiena Trešdiena Ceturtdiena
                       Piektdiena Sestdiena],
        wday_abbrs: %w[Sv P O T C P S],

        month_names:      %w[janvārī februārī martā aprīlī maijā jūnijā jūlijā
                             augustā septembrī oktobrī novembrī decembrī],
        month_abbrs:      %w[jan feb mar apr mai jūn jūl aug sep okt nov dec],
        month_standalone: %w[janvāris februāris marts aprīlis maijs jūnijs
                             jūlijs augusts septembris oktobris novembris
                             decembris],

        date_format: '%d.%m.%Y.',
        full_format: '%e.%B',
        year_format: '%Y.gada _',

        number_decimal: ',',
        number_group:   ' '
      )

      def pluralize(number)
        if number.zero?
          0
        elsif number % 10 == 1 && number % 100 != 11
          1
        else
          'n'
        end
      end
    end
  end
end
