module R18n
  class Locales::SrLatn < Locale
    set :title => 'Srpski',
        :sublocales => [],

        :week_start => :monday,
        :wday_names => %w{nedelja ponedeljak utorak sreda četvrtak petak
                          subota},
        :wday_abbrs => %w{ned pon uto sri čet pet sub},

        :month_names => %w{januar februar mart april maj juni juli avgust
                           septembar oktobar novembar decembar},
        :month_abbrs => %w{jan feb mar apr maj jun jul avg sep okt nov dec},

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
