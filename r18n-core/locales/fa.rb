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

    # Change numerals to Persian
    def format_integer(integer)
      persian_numerals super
    end

    # Change numerals to Persian
    def format_float(integer)
      persian_numerals super
    end

    # Change numerals to Persian
    def strftime(time, format)
      persian_numerals super
    end

    # Replace western numerals to Persian
    def persian_numerals(str)
      str.gsub('0', '۰')
         .gsub('1', '۱')
         .gsub('2', '۲')
         .gsub('3', '۳')
         .gsub('4', '۴')
         .gsub('5', '۵')
         .gsub('6', '۶')
         .gsub('7', '۷')
         .gsub('8', '۸')
         .gsub('9', '۹')
    end
  end
end
