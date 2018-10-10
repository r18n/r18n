# frozen_string_literal: true

require_relative 'en'

module R18n
  module Locales
    # American English locale
    class EnUs < En
      set(
        title: 'American English',
        sublocales: %w[en],

        time_format: '_ %I:%M %p',
        date_format: '%m/%d/%Y',
        full_format: '%B %-d'
      )
    end
  end
end
