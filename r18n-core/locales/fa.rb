module R18n
  class Locales::Fa < Locale
    set title: 'فارْسِى',

      wday_names: %w{یکشنبه دوشنبه سه‌شنبه چهارشنبه پنج‌شنبه جمعه شنبه},
        wday_abbrs: %w{ی د س چ پ ج ش},

        month_names: %w{ژانویه فوریه مارس آوریل مه ژوئن ژوئیه اوت سپتامبر اکتبر نوامبر دسامبر},
        month_abbrs: %w{ژانویه فوریه مارس آوریل مه ژوئن ژوئیه اوت سپتامبر اکتبر نوامبر دسامبر},

        date_format: '%Y/%m/%d',
        full_format: '%e %B',
        year_format: '_ %Y',

        number_decimal: '٫',
        number_group:   '٬'

    # Change direction
    def ltr?; false; end
  end
end
