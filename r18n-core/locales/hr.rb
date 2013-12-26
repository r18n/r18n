module R18n
  class Locales::Hr < Locale
    set :title => 'Hrvatski',

        :week_start => :monday,
        :wday_names => %w{Nedjelja Ponedjeljak Utorak Srijeda Četvrtak Petak
                          Subota},
        :wday_abbrs => %w{Ned Pon Uto Sri Čet Pet Sub},

        :month_names => %w{Siječanj Veljača Ožujak Travanj Svibanj Lipanj Srpanj Kolovoz
                           Rujan Listopad Studeni Prosinac},
        :month_abbrs => %w{Sij Velj Ožu Tra Svi Lip Srp Kol Ruj Lis Stu Pro},

        :date_format => '%d.%m.%Y',
        :full_format => '%e. %B',

        :number_decimal => ",",
        :number_group   => "."

    def pluralize(n)
      if 0 == n
        0
      elsif 1 == n % 10 and 11 != n % 100
        1
      elsif 2 <= n % 10 and 4 >= n % 10 and (10 > n % 100 or 20 <= n % 100)
        2
      else
        'n'
      end
    end
  end
end
