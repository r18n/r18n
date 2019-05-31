# frozen_string_literal: true

require_relative 'untranslated'

# Translation string for i18n support.
#
# Copyright (C) 2008 Andrey “A.I.” Sitnik <andrey@sitnik.ru>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

module R18n
  # String, which is translated to some locale and loading from Translation.
  class TranslatedString < String
    # String locale
    attr_reader :locale

    # Path for this translation.
    attr_reader :path

    # Returns a new string object containing a copy of +str+, which translated
    # for +path+ to +locale+
    def initialize(value, locale, path, filters = nil)
      super(value.to_s)
      @filters = filters
      @locale  = locale
      @path    = path
    end

    # Return self for translated string.
    def |(_other)
      self
    end

    # Return true for translated strings.
    def translated?
      true
    end

    # Return true if `html_safe` method is defined, otherwise false.
    def html_safe?
      respond_to? :html_safe
    end

    # Override to_s to make string html safe if `html_safe` method is defined.
    def to_s
      if html_safe?
        super.html_safe
      else
        String.new(super)
      end
    end

    # Define `as_json` for ActiveSupport compatibility.
    def as_json(_options = nil)
      to_str
    end

    # Override marshal_dump to avoid Marshalizing filter procs
    def _dump(_limit)
      [@locale.code, @path, to_str].join(':')
    end

    # Load object from Marshalizing.
    def self._load(str)
      arr = str.split(':', 3)
      new arr[2], R18n.locale(arr[0]), arr[1]
    end

    # Return untranslated for deeper node `key`. It is in separated methods to
    # be used in R18n I18n backend.
    def get_untranslated(key)
      translated = @path.empty? ? '' : "#{@path}."
      Untranslated.new(translated, key, @locale, @filters)
    end

    NON_KEYS_METHODS = [
      *Untranslated::NON_KEYS_METHODS,
      :html_safe,
      :to_text
    ].freeze

    # Return untranslated, when user try to go deeper in translation.
    def method_missing(name, *_params)
      return super if NON_KEYS_METHODS.include?(name)

      get_untranslated(name.to_s)
    end

    def respond_to_missing?(name, *args)
      return super if NON_KEYS_METHODS.include?(name)

      true
    end
  end
end
