# frozen_string_literal: true

module R18n
  module Locales
    # Swedish (Sweden) locale
    class SvSe < Locale
      set(
        title: 'Svenska',
        sublocales: %w[sv en],

        wday_names: %w[söndag måndag tisdag onsdag torsdag fredag lördag],
        wday_abbrs: %w[sön mån tis ons tor fre lör],

        month_names: %w[januari februari mars april maj juni juli augusti
                        september oktober november december],
        month_abbrs: %w[jan feb mar apr maj jun jul aug okt nov dec],

        date_format: '%Y-%m-%d',
        full_format: '%e %B %Y',

        number_decimal: ',',
        number_group:   '.'
      )
    end
  end
end
