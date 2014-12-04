module R18n
  class Locales::Da < Locale
    set title: 'Dansk',

        wday_names: %w{søndag mandag tirsdag onsdag torsdag fredag lørdag},
        wday_abbrs: %w{søn man tir ons tor fre lør},

        month_names: %w{januar februar marts april Maj juni juli august
                        september oktober november december},
        month_abbrs: %w{jan. feb. mar. apr. maj jun. jul. aug. sep. okt.
                        nov. dec.},

        time_am:     'om formiddagen',
        time_pm:     'om eftermiddagen',
        date_format: '%d.%m.%Y',
        full_format: '%d. %B %Y',

        number_decimal: ",",
        number_group:   "."
  end
end
