# frozen_string_literal: true

require_relative 'ru'

module R18n
  module Locales
    # Ukrainian locale
    class Uk < Ru
      set(
        title: 'Українська',
        sublocales: %w[ru en],

        wday_names: %w[Неділя Понеділок Вівторок Середа Четвер П'ятниця Субота],
        wday_abbrs: %w[Ндл Пнд Втр Срд Чтв Птн Сбт],

        month_names: %w[
          січня лютого березня квітня травня червня липня серпня вересня жовтня
          листопада грудня
        ],
        month_abbrs: %w[січ лют бер кві тра чер лип сер вер жов лис гру],
        month_standalone: %w[
          Січень Лютий Березень Квітень Травень Червень Липень Серпень Вересень
          Жовтень Листопад Грудень
        ],

        time_am: ' ранку',
        time_pm: ' вечора'
      )
    end
  end
end
