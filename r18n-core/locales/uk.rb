# encoding: utf-8
module R18n
  class Locales::Ua < Locale
    set :title => 'Українська',

        :wday_names => %w{Неділя Понеділок Вівторок Середа Четвер П'ятниця
                           Субота},
        :wday_abbrs => %w{Ндл Пнд Втр Срд Чтв Птн Сбт},

        :month_names => %w{січня лютого березня квітня травня червня липня серпня
                            вересня жовтня листопада грудня},
        :month_abbrs => %w{січ лют бер кві тра чер лип сер вер жов лис гру},
        :month_standalone => %w{Січень Лютий Березень Квітень Травень Червень Липень Серпень
                                 Вересень Жовтень Листопад Грудень},

        :time_am => ' ранку',
        :time_pm => ' вечора',
        :date_format => '%d.%m.%Y',

        :number_decimal => ",",
        :number_group   => " "

    def pluralize(n)
      if 0 == n
        0
      elsif 1 == n % 10 and 11 != n % 100
        1
      elsif 2 <= n % 10 and 4 >= n % 10 and (10 > n % 100 or 20 <= n % 100)
        2
      else
        'n'
      end
    end
  end
end
