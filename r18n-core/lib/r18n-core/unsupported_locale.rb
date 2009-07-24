# encoding: utf-8
=begin
Locale withou information file to i18n support.

Copyright (C) 2008 Andrey “A.I.” Sitnik <andrey@sitnik.ru>

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
  # Locale without information file. Contain only it code, empty title and data
  # from default locale.
  class UnsupportedLocale
    # Create object for unsupported locale with +code+ and load other locale
    # data from default locale.
    def initialize(code)
      @@default_locale ||= Locale.load(I18n.default)
      @code = code
    end
    
    # Is locale has information file. In this class always return false.
    def supported?
      false
    end
    
    # Human readable locale code and title
    def inspect
      "Unsupported locale #{@code}"
    end

    # Get information about locale
    def [](name)
      case name
      when 'code'
        @code
      when 'title'
        ''
      else
        @@default_locale[name]
      end
    end

    # Is another locale has same code
    def ==(locale)
      @code == locale['code']
    end
    
    #  Proxy to default locale object.
    def method_missing(name, *params)
      @@default_locale.send(name, *params)
    end
  end
end
