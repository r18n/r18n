module R18n
  class Locales::Vi < Locale
    set title: 'Vietnamese',
        sublocales: [],

        wday_names: ['Ch? nh?t', 'Th? hai', 'Th? ba', 'Th? t?', 'Th? n?m',
                     'Th? 6', 'Th? b?y'],
        wday_abbrs: %w{CN T2 T3 T4 T5 T6 T7},

        month_names: ['th�ng 1', 'th�ng 2', 'th�ng 3', 'th�ng 4',
                      'th�ng 5', 'th�ng 6', 'th�ng 7', 'th�ng 8',
                      'th�ng 9', 'th�ng 10', 'th�ng 11',
                      'th�ng 12'],
        month_abbrs: %w{th1 th2 th3 th4 th5 th6 th7 th8 th9 th10 th11 th12},

        date_format: '%d/%m/%Y',
        full_format: 'ngày %e %B',
        year_format: '_ năm %Y',
        time_format: '%H:%M, _',

        number_decimal: '.',
        number_group:   ','
  end
end
