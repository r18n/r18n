# frozen_string_literal: true

module R18n
  module Locales
    # Chinese locale
    class Zh < Locale
      set(
        title: '中文',

        wday_names: %w[星期日 星期一 星期二 星期三 星期四 星期五 星期六],
        wday_abbrs: %w[周日 周一 周二 周三 周四 周五 周六],

        month_names: %w[一月 二月 三月 四月 五月 六月 七月 八月 九月 十月 十一月
                        十二月],

        date_format: '%Y年%m月%d日',
        full_format: '%m月%d日',
        year_format: '%Y年_',

        number_decimal: '.',
        number_group:   ' '
      )

      def pluralize(_number)
        'n'
      end
    end
  end
end
