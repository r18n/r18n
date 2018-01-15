# frozen_string_literal: true

require_relative 'es'

module R18n
  module Locales
    # American Spanish locale
    class EsUs < Es
      set(
        title: 'Español Estadounidense',
        sublocales: %w[es en],

        time_format: ' %I:%M %p',
        date_format: '%m/%d/%Y',

        number_decimal: '.',
        number_group:   ','
      )
    end
  end
end
