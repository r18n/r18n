# frozen_string_literal: true

require File.join(File.dirname(__FILE__), 'en')

module R18n
  module Locales
    # Australian English locale
    class EnAu < En
      set title: 'Australian English',
          sublocales: %w[en]
    end
  end
end
