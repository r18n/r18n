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
  end
end