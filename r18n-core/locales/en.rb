module R18n
  class Locales::En < Locale
    set title: 'English',
        sublocales: [],

        week_start: :sunday,
        wday_names: %w{Sunday Monday Tuesday Wednesday Thursday Friday
                       Saturday},
        wday_abbrs: %w{Sun Mon Tue Wed Thu Fri Sat},

        month_names: %w{January February March April May June July August
                        September October November December},
        month_abbrs: %w{Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec},

        date_format: '%d/%m/%Y',
        full_format: '%e of %B',
        year_format: '_, %Y',

        number_decimal: ".",
        number_group:   ","

    def ordinalize(n)
      if (11..13).include?(n % 100)
        "#{n}th"
      else
        case n % 10
        when 1; "#{n}st"
        when 2; "#{n}nd"
        when 3; "#{n}rd"
        else    "#{n}th"
        end
      end
    end

    def format_date_full(date, year = true, *params)
      format = full_format
      format = year_format.sub('_', format) if year
      strftime(date, format.sub('%e', ordinalize(date.mday)))
    end
  end
end
