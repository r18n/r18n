# frozen_string_literal: true

module R18n
  module Locales
    # Welsh locale
    class Cy < Locale
      set(
        title: 'Welsh',
        sublocales: [],

        week_start: :sunday,
        wday_names: ["Dydd Sul", "Dydd Llun", "Dydd Mawrth", "Dydd Mercher", "Dydd Iau", "Dydd Gwener", "Dydd Sadwrn"],
        wday_abbrs: %w[Sul Llu Maw Mer Iau Gwe Sad],

        month_names: %w[Ionawr Chwefror Mawrth Ebrill Mai Mehefin Gorffennaf Awst Medi Hydref Tachwedd Rhagfyr],
        month_abbrs: %w[Ion Chw Maw Ebr Mai Meh Gor Aws Med Hyd Tac Rha],

        date_format: '%Y-%m-%d',
        full_format: '%e o %B',
        year_format: '_, %Y',

        number_decimal: '.',
        number_group:   ','
      )

      def ordinalize(n)
          case n % 10
            when 1 then "#{n}af"
            when 2 then "#{n}il"
            when 3 then "#{n}ydd"
            when 4 then "#{n}ydd"
            when 11 then "#{n}eg"
            when 13 then "#{n}eg"
            when 14 then "#{n}eg"
            when 16 then "#{n}eg"
            when 17 then "#{n}eg"
            when 19 then "#{n}eg"
            when 21 then "#{n}ain"
            when 22 then "#{n}ain"
            when 23 then "#{n}ain"
            when 24 then "#{n}ain"
            when 25 then "#{n}ain"
            when 26 then "#{n}ain"
            when 27 then "#{n}ain"
            when 28 then "#{n}ain"
            when 29 then "#{n}ain"
            when 30 then "#{n}ain"
            when 31 then "#{n}ain"
            else "#{n}ed"
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
