# encoding: utf-8
module R18n
  class Locales::Hu < Locale
    set :title => 'Magyar',

        :week_start => :monday,
        :wday_names => %w{vasárnap hétfő kedd szerda csütörtök péntek szombat},
        :wday_abbrs => %w{vas hét ked sze csü pén szo},

        :month_names => %w{január február március április május június július
                           augusztus szeptember október november december},
        :month_abbrs => %w{jan feb már ápr máj jún júl aug sze okt nov dec},

        :date_format => '%Y. %m. %d.',
        :full_format => '%B %e.',
        :year_format => '%Y. _',
        :time_format => '%H:%M',

        :number_decimal => ",",
        :number_group   => " "

    def format_integer(integer)
      str = integer.to_s
      str[0] = '−' if 0 > integer # Real typographic minus
      group = number_group

      # only group numbers if it has at least 5 digits
      # http://hu.wikisource.org/wiki/A_magyar_helyes%C3%ADr%C3%A1s_szab%C3%A1lyai/Az_%C3%ADr%C3%A1sjelek#274.
      if integer.abs >= 10000
        str.gsub(/(\d)(?=(\d\d\d)+(?!\d))/) do |match|
          match + group
        end
      else
        str
      end
    end

    def format_time_standard(time, *params)
      format_date_standard(time) + ', ' + format_time(time)
    end

    def format_time_full(time, *params)
      format_date_full(time) + ', ' + format_time(time)
    end
  end
end
