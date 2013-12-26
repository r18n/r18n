module R18n
  class Locales::HrHr < Locale
    set :title => 'Hrvatski',
        :sublocales => [],

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
  end
end