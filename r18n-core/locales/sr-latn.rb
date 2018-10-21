# frozen_string_literal: true

module R18n
  module Locales
    # Serbian Latin locale
    class SrLatn < Locale
      set title: 'Srpski',
          sublocales: [],

          week_start: :monday,
          wday_names: %w[nedelja ponedeljak utorak sreda četvrtak petak subota],
          wday_abbrs: %w[ned pon uto sri čet pet sub],

          month_names: %w[januar februar mart april maj juni juli avgust
                          septembar oktobar novembar decembar],
          month_abbrs: %w[jan feb mar apr maj jun jul avg sep okt nov dec],

          date_format: '%d.%m.%Y',
          full_format: '%e. %B',

          number_decimal: ',',
          number_group:   '.'

      def pluralize(number)
        if number.zero?
          0
        elsif number == 1
          1
        elsif number >= 2 && number <= 4
          2
        else
          'n'
        end
      end
    end
  end
end
