module R18n
  class Locales::Kk < Locale
    set title: 'Қазақша',
        sublocales: %w{ru en},

        wday_names: %w{Жексенбі Дүйсенбі Сейсенбі Сәрсенбі Бейсенбі Жұма Сенбі},
        wday_abbrs: %w{Жк Дс Сс Ср Бс Жм Сн},

        month_names: %w{қаңтар ақпан наурыз сәуір мамыр маусым шілде тамыз
                        қырқүйек қазан қараша желтоқсан},
        month_abbrs: %w{қаң ақп нау сәу мам мау шіл там қыр қаз қар жел},
        month_standalone: %w{Қаңтар Ақпан Наурыз Сәуір Мамыр Маусым Шілде
                             Тамыз Қыркүйек Қазан Қараша Желтоқсан},

        time_am:     ' ертеңің',
        time_pm:     ' кештің',
        date_format: '%Y-%m-%d',
        full_format: '%B %e-і',
        year_format: '%Y жылы _',

        number_decimal: ",",
        number_group:   " "
  end
end
