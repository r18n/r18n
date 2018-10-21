# frozen_string_literal: true

module R18n
  module Locales
    # Czech locale
    class Cs < Locale
      set(
        title: 'Český',
        sublocales: %w[cz sk en],

        wday_names: %w[Neděle Pondělí Úterý Středa Čtvrtek Pátek Sobota],
        wday_abbrs: %w[Ne Po Út St Čt Pá So],

        month_names: %w[ledna února března dubna května června července srpna
                        září října listopadu prosince],
        month_abbrs: %w[led úno bře dub kvě čer čvc srp zář říj lis pro],
        month_standalone: %w[Leden Únor Březen Duben Květen Červen Červenec
                             Srpen Září Říjen Listopad Prosinec],

        time_am:     'dop.',
        time_pm:     'odp.',
        date_format: '%e. %m. %Y',
        full_format: '%e. %B',

        number_decimal: ',',
        number_group:   ' '
      )

      def pluralize(number)
        case number
        when 0
          0
        when 1
          1
        when 2..4
          2
        else
          'n'
        end
      end
    end
  end
end
