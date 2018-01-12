# frozen_string_literal: true

require File.join(File.dirname(__FILE__), 'en')

module R18n
  module Locales
    # British English locale
    class EnGb < En
      set(
        title: 'British English',
        sublocales: %w[en],

        date_format: '%d/%m/%Y'
      )
    end
  end
end
