# frozen_string_literal: true

module R18n
  module Locales
    # Bulgarian locale
    class Bg < Locale
      set(
        title:  'Български',

        wday_names: %w[Неделя Понеделник Вторник Сряда Четвъртък Петък Събота],
        wday_abbrs: %w[Нед Пон Вто Сря Чет Пет Съб],

        month_names:      %w[Януари Февруари Март Април Май Юни Юли Август
                             Септември Октомври Ноември Декември],
        month_abbrs:      %w[Яну Фев Мар Апр Май Юни Юли Авг Сеп Окт Ное Дек],
        month_standalone: %w[Януари Февруари Март Април Май Юни Юли Август
                             Септември Октомври Ноември Декември],
        date_format: '%d.%m.%Y',

        number_decimal: ',',
        number_group:   ' '
      )
    end
  end
end
