# frozen_string_literal: true

module R18n
  module Locales
    # Mongolian locale
    class Mn < Locale
      set(
        title: 'Монгол',

        wday_names: ['Ням гариг', 'Даваа гариг', 'Мягмар гариг', 'Лхагва гариг',
                     'Пүрэв гариг', 'Баасан гариг', 'Бямба гариг'],
        wday_abbrs: %w[ня да мя лх пү ба бя],

        month_names: ['Нэгдүгээр сар',   'Хоёрдугаар сар', 'Гуравдугаар сар',
                      'Дөрөвдүгээр сар', 'Тавдугаар сар',  'Зургадугаар сар',
                      'Долдугаар сар',   'Наймдугаар сар', 'Есдүгээр сар',
                      'Аравдугаар сар',  'Арваннэгдүгээр сар',
                      'Арванхоёрдугаар сар'],

        date_format: '%Y-%m-%d',

        number_decimal: ',',
        number_group:   '.'
      )
    end
  end
end
