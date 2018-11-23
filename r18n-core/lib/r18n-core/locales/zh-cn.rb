# frozen_string_literal: true

require_relative 'zh'

module R18n
  module Locales
    # Chinese (S) locale
    class ZhCN < Zh
      set(
        title: '简体中文',
        sublocales: %w[zh en]
      )
    end
  end
end
