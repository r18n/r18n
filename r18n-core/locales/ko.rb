# encoding: utf-8
module R18n
  class Locales::Ko < Locale
    set title: '한국어',

        wday_names: %w{일요일 월요일 화요일 수요일 목요일 금요일 토요일},
        wday_abbrs: %w{일 월 화 수 목 금 토},

        month_names: %w{1월 2월 3월 4월 5월 6월 7월 8월 9월 10월 11월 12월},
        month_abbrs: %w{1 2 3 4 5 6 7 8 9 10 11 12},

        date_format: '%Y/%m/%d',
        full_format: '%m월 %d일',
        year_format: '%Y년 _',

        number_decimal: ".",
        number_group: ","
  end
end
