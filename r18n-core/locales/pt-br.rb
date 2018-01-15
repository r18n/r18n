# frozen_string_literal: true

require File.join(File.dirname(__FILE__), 'pt')

module R18n
  module Locales
    # Brazilian Portuguese locale
    class PtBr < Pt
      set(
        title: 'Português brasileiro',
        sublocales: %w[pt en]
      )
    end
  end
end
