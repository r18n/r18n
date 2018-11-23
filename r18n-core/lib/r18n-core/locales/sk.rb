# frozen_string_literal: true

module R18n
  module Locales
    # Slovak locale
    class Sk < Locale
      set(
        title: 'Slovenský',
        sublocales: %w[cs cz en],

        wday_names: %w[Nedeľa Pondelok Utorok Streda Štvrtok Piatok Sobota],
        wday_abbrs: %w[Ne Po Ut St Št Pi So],

        month_names:      %w[januára februára marca apríla mája júna júla
                             augusta septembra októbra novembra decembra],
        month_abbrs:      %w[jan feb mar apr máj jún júl aug sep okt nov dec],
        month_standalone: %w[Január Február Marec Apríl Máj Jún Júl August
                             September Október November December],

        time_am: 'dop.',
        time_pm: 'odp.',
        date_format: '%d.%m.%Y',
        full_format: '%-d. %B',

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
