=begin
I18n support.

Copyright (C) 2008 Andrey “A.I.”" Sitnik <andrey@sitnik.ru>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Lesser General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
=end

module R18n
  # General class to i18n support in your application.
  class I18n
    @@default = 'en'

    # Set default locale code to use when any user locales willn't be founded.
    # It should has all translations and locale file.
    def self.default=(locale)
      @@default = locale
    end

    # Get default locale code
    def self.default
      @@default
    end
    
    # Parse HTTP_ACCEPT_LANGUAGE and return array of user locales
    def self.parse_http_accept_language(str)
      return [] if str.nil?
      locales = str.split(',')
      locales.map! do |locale|
        locale = locale.split ';q='
        if 1 == locale.size
          [locale[0], 1.0]
        else
          [locale[0], locale[1].to_f]
        end
      end
      locales.sort! { |a, b| b[1] <=> a[1] }
      locales.map! { |i| i[0] }
    end
  end
end
