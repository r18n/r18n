module R18n
  module Locales
    class Pl < R18n::Locale
      def pluralize(n)
        return 0 if n == 0
        # 0 - 0
        # 1 - 1
        # 2..4 - 2
        # n
    
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
end