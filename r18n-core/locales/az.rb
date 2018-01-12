# frozen_string_literal: true

module R18n
  module Locales
    # Azerbaijani locale
    class Az < Locale
      set(
        title: 'Azərbaycanca',

        wday_names: %w[Bazar BazarErtəsi ÇərşənbəAxşamı Çərşənbə CüməAxşamı Cümə
                       Şənbə],
        wday_abbrs: %w[B. B.e Ç.a Ç. C.a C. Ş.],

        month_names:      %w[yanvar fevral mart aprel may iyun iyul avqust
                             sentyabr oktyabr noyabr dekabr],
        month_abbrs:      %w[yan fev mar apr may iyn iyl avq sen okt noy dek],
        month_standalone: %w[Yanvar Fevral Mart Aprel May İyun İyul Avqust
                             Sentyabr Oktyabr Noyabr Dekabr],

        time_am:     ' gündüz',
        time_pm:     ' axşam',
        date_format: '%d.%m.%Y',
        time_format: '_%H:%M',

        number_decimal: ',',
        number_group:   ' '
      )

      def pluralize(_n)
        'n'
      end
    end
  end
end
