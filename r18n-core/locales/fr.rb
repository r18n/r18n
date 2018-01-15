# frozen_string_literal: true

module R18n
  module Locales
    # French locale
    class Fr < Locale
      set(
        title: 'Français',

        wday_names: %w[dimanche lundi mardi mercredi jeudi vendredi samedi],
        wday_abbrs: %w[dim lun mar mer jeu ven sam],

        month_names:      %w[janvier février mars avril mai juin juillet août
                             septembre octobre novembre décembre],
        month_abbrs:      %w[jan fév mar avr mai jun jui aoû sep oct nov déc],
        month_standalone: %w[Janvier Février Mars Avril Mai Juin Juillet Août
                             Septembre Octobre Novembre Décembre],

        date_format: '%d/%m/%Y',

        number_decimal: ',',
        number_group:   ' '
      )

      def format_date_full(date, year = true, *_params)
        full = super(date, year)
        if full[0..1] == ' 1'
          '1er' + full[2..-1]
        else
          full
        end
      end
    end
  end
end
