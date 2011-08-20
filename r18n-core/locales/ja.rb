# encoding: utf-8
module R18n
  class Locales::Ja < Locale
    set :title => '日本語',

        :week_start => :sunday,
        :wday_names => %w{日曜日 月曜日 火曜日 水曜日 木曜日 金曜日 土曜日},
        :wday_abbrs => %w{日 月 火 水 木 金 土},

        :month_names => %w{一月 二月 三月 四月 五月 六月 七月 八月 九月 十月
                           十一月 十二月},

        :date_format => '%Y年%m月%d日',
        :full_format => '%m月%d日',
        :year_format => '%Y年_',

        :number_decimal => ".",
        :number_group   => ","
  end
end
