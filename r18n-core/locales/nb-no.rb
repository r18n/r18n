#encoding: utf-8
module R18n
  class Locales::NbNo < Locale
    set :title => 'Norsk', #Bokmål
        :code  => 'nb-NO',
        :sublocales => %w{no nn-NO},

        :week_start => :monday,
        :wday_names => %w{søndag mandag tirsdag onsdag torsdag fredag lørdag},
        :wday_abbrs => %w{søn man tir ons tor fre lør},

        :month_names => %w{januar februar mars april mai juni juli august
                           september oktober november desember},
        :month_abbrs => %w{jan feb mar apr mai jun jul aug sep okt nov des},

        :date_format => '%d.%m.%Y',
        :full_format => '%e. %B %Y',

        :number_decimal => ",",
        :number_group =>   " "
  end
end
