module R18n
  class Locales::Ja < Locale
    @@jp_month = %w{一月 二月 三月 四月 五月 六月 七月 八月 九月 十月 十一月 十二月}
    set :title => 'Japanese',
        :sublocales => [],
        
        :week_start => :sunday,
        :wday_names => %w{日曜日 月曜日 火曜日 水曜日 木曜日 金曜日 土曜日},
        :wday_abbrs => %w{日 月 火 水 木 金 土},
        
        :month_names => @@jp_month,
        :month_abbrs => @@jp_month,
        
        :date_format => '%Y年%m月%d日',
        :full_format => '%m月%d日',
        :year_format => '%Y年_',

        :number_decimal => ".",
        :number_group =>   ","
    
    def ordinalize(n)
      "#{n}番目"
    end
  end
end
