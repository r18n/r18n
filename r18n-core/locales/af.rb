module R18n
  class Locales::Af < Locale
    set title: 'Afrikaans',

        week_start: :sondag,
        wday_names: %w{Sondag Maandag Dinsdag Woensdag Donderdag Vrydag
                       Saterdag},
        wday_abbrs: %w{So Ma Di Wo Do Vr Sa},

        month_names: %w{Januarie Februarie Maart April Mei Junie Julie Augustus
                        September Oktober November Desember},
        month_abbrs: %w{Jan Feb Mrt Apr Mei Jun Jul Aug Sep Okt Nov Des},

        time_am:     "'s voormiddag",
        time_pm:     "'s namiddag",

        date_format: '%d/%m/%Y',
        full_format: '%e %B',
        year_format: '_, %Y',
        time_format: '_, %H:%M',

        number_decimal: '.',
        number_group:   ','
  end
end
