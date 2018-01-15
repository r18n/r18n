# frozen_string_literal: true

require_relative 'zh'

module R18n
  module Locales
    # Chinese (T) locale
    class ZhTw < Zh
      set(
        title: '繁體中文',
        sublocales: %w[zh en],

        wday_names:  %w[星期日 星期壹 星期二 星期三 星期四 星期五 星期六],
        wday_abbrs:  %w[周日 周壹 周二 周三 周四 周五 周六],
        month_names: %w[壹月 二月 三月 四月 五月 六月 七月 八月 九月 十月 十壹月 十二月]
      )
    end
  end
end
