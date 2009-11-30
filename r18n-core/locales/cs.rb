module R18n
  module Locales
    class Cs < R18n::Locale
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
end

