# frozen_string_literal: true

module R18n
  module Locales
    # Welsh locale
    class Cy < Locale
      set(
        title: 'Welsh',
        sublocales: [],

        week_start: :sunday,
        wday_names: [
          'Dydd Sul', 'Dydd Llun', 'Dydd Mawrth', 'Dydd Mercher', 'Dydd Iau',
          'Dydd Gwener', 'Dydd Sadwrn'
        ],
        wday_abbrs: %w[Sul Llu Maw Mer Iau Gwe Sad],

        month_names: %w[
          Ionawr Chwefror Mawrth Ebrill Mai Mehefin Gorffennaf Awst Medi Hydref
          Tachwedd Rhagfyr
        ],
        month_abbrs: %w[Ion Chw Maw Ebr Mai Meh Gor Aws Med Hyd Tac Rha],

        date_format: '%Y-%m-%d',
        full_format: '%e o %B',
        year_format: '_, %Y',

        number_decimal: '.',
        number_group: ','
      )

      def ordinalize(number)
        case number % 10
        when 1 then "#{number}af"
        when 2 then "#{number}il"
        when 3, 4 then "#{number}ydd"
        when 11, 13, 14, 16, 17, 19 then "#{number}eg"
        when 21..31 then "#{number}ain"
        else "#{number}ed"
        end
      end

      def format_date_full(date, year = true, *_params)
        format = full_format
        format = year_format.sub('_', format) if year
        strftime(date, format.sub('%e', ordinalize(date.mday)))
      end
    end
  end
end
