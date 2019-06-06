# frozen_string_literal: true

require_relative 'en'

module R18n
  module Locales
    # American English locale
    class EnUS < En
      set(
        title: 'American English',
        sublocales: %w[en],

        time_format: '_ %I:%M %p',
        time_with_seconds_format: '_ %r',
        date_format: '%m/%d/%Y',
        full_format: '%B %-d'
      )
    end
  end
end
