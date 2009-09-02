module R18n
  module Locales
    class Cs < R18n::Locale
      def pluralize(n)
        return 0 if n == 0
        # 0 - 0
        # 1 - 1
        # 2..4 - 2
        # n
    
        case n
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
end

