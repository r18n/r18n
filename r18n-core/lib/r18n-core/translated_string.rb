# encoding: utf-8
=begin
Translation string for i18n support.

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
  # String, which is translated to some locale and loading from Translation.
  class TranslatedString < String
    # String locale
    attr_reader :locale

    # Path for this translation.
    attr_reader :path

    # Returns a new string object containing a copy of +str+, which translated
    # for +path+ to +locale+
    def initialize(str, locale, path)
      super(str)
      @locale = locale
      @path   = path
    end

    # Return self for translated string.
    def |(default)
      self
    end

    # Return true for translated strings.
    def translated?
      true
    end
  end
end
