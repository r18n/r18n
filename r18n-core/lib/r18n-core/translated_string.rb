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
    def initialize(str, locale, path, filters = nil)
      super(str)
      @filters = filters
      @locale  = locale
      @path    = path
    end

    # Return self for translated string.
    def |(default)
      self
    end

    # Return true for translated strings.
    def translated?
      true
    end

    # Mark translated string as html safe, because R18n has own escape system.
    def html_safe?
      true
    end

    # Override to_s to make string html safe if `html_safe` method is defined.
    def to_s
      if respond_to? :html_safe
        html_safe
      else
        String.new(self)
      end
    end

    # Override marshal_dump to avoid Marshalizing filter procs
    def marshal_dump
      self.to_str
    end

    # Return untranslated for deeper node `key`. It is in separated methods to
    # be used in R18n I18n backend.
    def get_untranslated(key)
      translated = @path.empty? ? '' : "#{@path}."
      Untranslated.new(translated, key, @locale, @filters)
    end

    # Return untranslated, when user try to go deeper in translation.
    def method_missing(name, *params)
      get_untranslated(name.to_s)
    end
  end
end
