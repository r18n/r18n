# frozen_string_literal: true

require_relative 'en'

module R18n
  module Locales
    # British English locale
    class EnGB < En
      set(
        title: 'British English',
        sublocales: %w[en en-US en-AU],

        date_format: '%d/%m/%Y'
      )
    end
  end
end
