# frozen_string_literal: true

module R18n
  module Locales
    # Norwegian Bokmål locale
    class Nb < Locale
      set(
        title: 'Norsk (bokmål)',
        sublocales: %w[nn en],

        week_start: :monday,
        wday_names: %w[søndag mandag tirsdag onsdag torsdag fredag lørdag],
        wday_abbrs: %w[søn man tir ons tor fre lør],

        month_names: %w[januar februar mars april mai juni juli august
                        september oktober november desember],
        month_abbrs: %w[jan feb mar apr mai jun jul aug sep okt nov des],

        date_format: '%d.%m.%Y',
        full_format: '%e. %B %Y',

        number_decimal: ',',
        number_group:   ' '
      )
    end
  end
end
