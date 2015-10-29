module R18n
  class Locales::Vi < Locale
    set title: 'Tiếng Việt',

        wday_names: ['Chủ nhật', 'Thứ Hai', 'Thứ Ba', 'Thứ Tư', 'Thứ Năm',
                     'Thứ Sáu', 'Thứ Bảy'],
        wday_abbrs: %w{CN T2 T3 T4 T5 T6 T7},

        month_names: ['tháng 1', 'tháng 2', 'tháng 3', 'tháng 4', 'tháng 5',
                      'tháng 6', 'tháng 7', 'tháng 8',' tháng 9', 'tháng 10',
                      'tháng 11', 'tháng 12'],
        month_abbrs: %w{th1 th2 th3 th4 th5 th6 th7 th8 th9 th10 th11 th12},

        date_format: '%d/%m/%Y',
        full_format: 'ngày %e %B',
        year_format: '_ năm %Y',
        time_format: '%H:%M, _',

        number_decimal: '.',
        number_group:   ','

    def pluralize(n)
      'n'
    end
  end
end
