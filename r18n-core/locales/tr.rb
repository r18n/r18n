module R18n
  class Locales::Tr < Locale
    set title: 'Türkçe',

        wday_names: %w{Pazar Pazartesi Salı Çarşamba Perşembe Cuma Cumartesi},
        wday_abbrs: %w{Paz Pzt Sal Çar Per Cum Cmt},

        month_names: %w{Ocak Şubat Mart Nisan Mayıs Haziran Temmuz Ağustos Eylül
                        Ekim Kasım Aralık},
        month_abbrs: %w{Oca Şub Mar Nis May Haz Tem Ağu Eyl Eki Kas Ara},

        date_format: '%d.%m.%Y',
        full_format: '%B %e.',
        year_format: '%Y. _',
        time_format: '%H:%M',

        number_decimal: ".",
        number_group:   ","
  end
end
