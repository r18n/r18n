# frozen_string_literal: true

module R18n
  module Locales
    # Persian locale
    class Fa < Locale
      set(
        title: 'فارْسِى',

        wday_names: %w[
          یکشنبه دوشنبه سه‌شنبه چهارشنبه پنج‌شنبه جمعه شنبه
        ],
        wday_abbrs: %w[ی د س چ پ ج ش],

        month_names: %w[
          ژانویه فوریه مارس آوریل مه ژوئن ژوئیه اوت سپتامبر اکتبر نوامبر دسامبر
        ],
        month_abbrs: %w[
          ژانویه فوریه مارس آوریل مه ژوئن ژوئیه اوت سپتامبر اکتبر نوامبر دسامبر
        ],

        date_format: '%Y/%m/%d',
        full_format: '%e %B',
        year_format: '_ %Y',

        number_decimal: '٫',
        number_group:   '٬'
      )

      # Change direction
      def ltr?
        false
      end

      # Change numerals to Persian
      def format_integer(integer)
        persian_numerals super
      end

      # Change numerals to Persian
      def format_float(integer)
        persian_numerals super
      end

      # Change numerals to Persian
      def strftime(time, format)
        persian_numerals super
      end

      # Replace western numerals to Persian
      def persian_numerals(str)
        str
          .tr('0', '۰')
          .tr('1', '۱')
          .tr('2', '۲')
          .tr('3', '۳')
          .tr('4', '۴')
          .tr('5', '۵')
          .tr('6', '۶')
          .tr('7', '۷')
          .tr('8', '۸')
          .tr('9', '۹')
      end
    end
  end
end
