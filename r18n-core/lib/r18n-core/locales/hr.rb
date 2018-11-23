# frozen_string_literal: true

module R18n
  module Locales
    # Croatian locale
    class Hr < Locale
      set(
        title: 'Hrvatski',

        week_start: :monday,
        wday_names: %w[Nedjelja Ponedjeljak Utorak Srijeda Četvrtak Petak
                       Subota],
        wday_abbrs: %w[Ned Pon Uto Sri Čet Pet Sub],

        month_names: %w[Siječanj Veljača Ožujak Travanj Svibanj Lipanj Srpanj
                        Kolovoz Rujan Listopad Studeni Prosinac],
        month_abbrs: %w[Sij Velj Ožu Tra Svi Lip Srp Kol Ruj Lis Stu Pro],

        date_format: '%d.%m.%Y',
        full_format: '%-d. %B',

        number_decimal: ',',
        number_group:   '.'
      )

      def pluralize(number)
        if number.zero?
          0
        elsif number == 1
          1
        elsif number >= 2 && number <= 4
          2
        else
          'n'
        end
      end
    end
  end
end
