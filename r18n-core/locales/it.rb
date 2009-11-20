# encoding: utf-8
module R18n
  module Locales
    class It < R18n::Locale
      def format_date_full(i18n, date, year = true)
        full = super(i18n, date, year)
        if ' 1' == full[0..1]
          "1º" + full[2..-1]
        else
          full
        end
      end
    end
  end
end
