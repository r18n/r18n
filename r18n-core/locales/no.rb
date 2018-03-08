# frozen_string_literal: true

require_relative 'nb'

module R18n
  module Locales
    # @deprecated Norwegian locale
    class No < Nb
      class << self
        extend Gem::Deprecate
        deprecate :new, 'R18n::Locales::Nb.new', 2019, 1
      end
    end
  end
end
