# frozen_string_literal: true

module R18n
  module Locales
    # Polish locale
    class Pl < Locale
      set(
        title: 'Polski',

        wday_names: %w[niedziela poniedziałek wtorek środa czwartek piątek
                       sobota],
        wday_abbrs: %w[nd pn wt śr czw pt sob],

        month_names:      %w[stycznia lutego marca kwietnia maja czerwca lipca
                             sierpnia września października listopada grudnia],
        month_abbrs:      %w[I II III IV V VI VII VIII IX X XI XII],
        month_standalone: %w[styczeń luty marzec kwiecień maj czerwiec lipiec
                             sierpień wrzesień październik listopad
                             grudzień],

        date_format: '%d.%m.%Y',

        number_decimal: ',',
        number_group:   ' '
      )

      def pluralize(n)
        return 0 if n.zero?
        case n % 10
        when 1
          n > 10 ? 'n' : 1
        when 2..4
          (11..19).cover?(n % 100) ? 'n' : 2
        else
          'n'
        end
      end
    end
  end
end
