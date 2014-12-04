module R18n
  class Locales::Fi < Locale
    set title: 'Suomi',

        wday_names: %w{sunnuntai maanantai tiistai keskiviikko torstai
                       terjantai lauantai},
        wday_abbrs: %w{su ma ti ke to te la},

        month_names:      %w{tammikuuta helmikuuta maaliskuuta huhtikuuta
                             toukokuuta kesäkuuta heinäkuuta elokuuta syyskuuta
                             lokakuuta marraskuuta joulukuuta},
        month_abbrs:      %w{tam hel maa huh tou kes hei elo syy lok mar jou},
        month_standalone: %w{tammikuu helmikuu maaliskuu huhtikuu toukokuu
                             kesäkuu heinäkuu elokuu syyskuu lokakuu
                             marraskuu joulukuu},

        date_format: '%d.%m.%Y',
        time_format: ' %H.%M',
        full_format: '%e. %B',

        number_decimal: ",",
        number_group:   " "

    def format_time_full(time, *params)
      format_date_full(time) + ' kello' + format_time(time)
    end
  end
end
