# frozen_string_literal: true

module R18n
  module Locales
    # Russian locale
    class Ru < Locale
      set(
        title: 'Русский',

        wday_names: %w[Воскресенье Понедельник Вторник Среда Четверг Пятница
                       Суббота],
        wday_abbrs: %w[Вск Пнд Втр Срд Чтв Птн Сбт],

        month_names:      %w[января февраля марта апреля мая июня июля августа
                             сентября октября ноября декабря],
        month_abbrs:      %w[янв фев мар апр май июн июл авг сен окт ноя дек],
        month_standalone: %w[Январь Февраль Март Апрель Май Июнь Июль Август
                             Сентябрь Октябрь Ноябрь Декабрь],

        time_am:     ' утра',
        time_pm:     ' вечера',
        date_format: '%d.%m.%Y',

        number_decimal: ',',
        number_group:   ' '
      )

      def pluralize(n)
        if n.zero?
          0
        elsif n % 10 == 1 && n % 100 != 11
          1
        elsif (2..4).cover?(n % 10) && !(10..19).cover?(n % 100)
          2
        else
          'n'
        end
      end
    end
  end
end
