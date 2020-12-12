# frozen_string_literal: true

module R18n
  module Locales
    # English locale
    class En < Locale
      set(
        title: 'English',
        sublocales: %w[en-US en-GB en-AU],

        week_start: :sunday,
        wday_names: %w[
          Sunday Monday Tuesday Wednesday Thursday Friday Saturday
        ],
        wday_abbrs: %w[Sun Mon Tue Wed Thu Fri Sat],

        month_names: %w[
          January February March April May June July August September October
          November December
        ],
        month_abbrs: %w[Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec],

        date_format: '%Y-%m-%d',
        full_format: '%-d of %B',
        year_format: '_, %Y',

        number_decimal: '.',
        number_group: ','
      )

      def ordinalize(number)
        if (11..13).cover?(number % 100)
          "#{number}th"
        else
          case number % 10
          when 1 then "#{number}st"
          when 2 then "#{number}nd"
          when 3 then "#{number}rd"
          else        "#{number}th"
          end
        end
      end

      def format_date_full(date, year: true, **_kwargs)
        format = full_format
        format = year_format.sub('_', format) if year
        strftime(date, format.sub('%-d', ordinalize(date.mday)))
      end
    end
  end
end
