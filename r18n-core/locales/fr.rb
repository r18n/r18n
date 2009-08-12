module R18n
  module Locales
    class Fr < R18n::Locale
      def format_date_full(i18n, date, year = true)
        full = super(i18n, date, year)
        if ' 1' == full[0..1]
          '1er' + full[2..-1] 
        else
          full
        end
      end
    end
  end
end
