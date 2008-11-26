module R18n
  module Locales
    class Ru < R18n::Locale
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
end
