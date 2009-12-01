# encoding: utf-8
module R18n
  class Locales::Cs < Locale
    set :title, 'Český',
        :sublocales, %w{cz sk en},
        
        :wday_names, %w{Neděle Pondělí Úterý Středa Čtvrtek Pátek Sobota},
        :wday_abbrs, %w{Ne Po Út St Čt Pá So},
        
        :month_names, %w{Ledna Února Března Dubna Května Června Července Srpna
                         Září Října Listopadu Prosince},
        :month_abbrs, %w{Led Úno Bře Dub Kvě Čer Čvc Srp Zář Říj Lis Pro},
        :month_standalone, %w{Leden Únor Březen Duben Květen Červen Červenec
                              Srpen Září Říjen Listopad Prosinec},
        
        :time_am, 'dop.',
        :time_pm, 'odp.',
        :date_format, '%d.%m.%Y',
        
        :number_decimal, ",",
        :number_group,   " "
    
    def pluralize(n)
      case n
      when 0
        0
      when 1
        1
      when 2..4
        2
      else
        'n'
      end
    end
  end
end

