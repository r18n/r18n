# encoding: utf-8
module R18n
  class Locales::Sk < Locale
    set :title => 'Slovensky',
        :sublocales => %w{sk cz en},
        
        :wday_names => %w{Nedela Pondelok Utorok Streda Štvrtok Piatok Sobota},
        :wday_abbrs => %w{Ne Po Ut St Št Pi So},
        
        :month_names => %w{Januára Februára Marca Apríla Mája Júna Júla Augusta Septembra Októbra Novembra Decembra},
        :month_abbrs => %w{Jan Feb Mar Apr Máj Jún Júl Aug Sep Okt Nov Dec},
        :month_standalone => %w{Január Február Marec Apríl Máj Jún Júl August September Október November December},
        
        :time_am => 'dop.',
        :time_pm => 'odp.',
        :date_format => '%d.%m.%Y',
        
        :number_decimal => ",",
        :number_group   => " "
    
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

