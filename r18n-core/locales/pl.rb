# encoding: utf-8
module R18n
  class Locales::Pl < R18n::Locale
    set :title => 'Polski',
        
        :wday_names => %w{niedziela poniedziałek wtorek środa czwartek piątek
                          sobota},
        :wday_abbrs => %w{nd pn wt śr czw pt sob},
        
        :month_names => %w{stycznia lutego marca kwietnia maja czerwca lipca
                           sierpnia września pażdziernika listopada grudnia},
        :month_abbrs => %w{I II III IV V VI VII VIII IX X XI XII},
        :month_standalone => %w{styczeń luty marzec kwiecień maj czerwiec lipiec
                                sierpień wrzesień październik listopad
                                grudzień},
        
        :date_format => '%d.%m.%Y',
        
        :number_decimal => ",",
        :number_group   => " "
    
    def pluralize(n)
      return 0 if n == 0
      case n % 10
      when 1
        n > 10 ? 'n' : 1
      when 2..4
        n % 100 > 10 && n % 100 < 20 ? 'n' : 2
      else
        'n'
      end
    end
  end
end
