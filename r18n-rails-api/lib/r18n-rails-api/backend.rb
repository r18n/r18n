# encoding: utf-8
=begin
R18n backend for Rails I18n.

Copyright (C) 2009 Andrey “A.I.” Sitnik <andrey@sitnik.ru>

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
  # R18n backend for Rails I18n. You must set R18n I18n object before use this
  # backend:
  #
  #   R18n.set locales, R18n::Loader::Rails
  #
  #   I18n.l Time.now, :format => :full #=> "6th of December, 2009 22:44"
  class Backend
    RESERVED_KEYS = [:scope, :default, :separator]

    # Find translation in R18n. It didn’t use +locale+ argument, only current
    # R18n I18n object. Also it doesn’t support Proc and variables in +default+
    # String option.
    def translate(locale, key, options = {})
      return key.map { |k| translate(locale, k, options) } if key.is_a?(Array)

      scope, default, separator = options.values_at(*RESERVED_KEYS)
      params = options.reject { |name, value| RESERVED_KEYS.include?(name) }

      result = lookup(scope, key, separator, params)

      if result.is_a? Untranslated
        options = options.reject { |key, value| key == :default }

        Array(default).each do |entry|
          if entry.is_a? Symbol
            value = lookup(scope, entry, separator, params)
            return value unless value.is_a? Untranslated
          else
            return entry
          end
        end

        raise ::I18n::MissingTranslationData.new(locale, key, options)
      else
        result
      end
    end

    # Convert +object+ to String, according to the rules of the current
    # R18n locale. It didn’t use +locale+ argument, only current R18n I18n
    # object. It support Fixnum, Bignum, Float, Time, Date and DateTime.
    #
    # Support Rails I18n (+:default+, +:short+, +:long+, +:long_ordinal+,
    # +:only_day+ and +:only_second+) and R18n (+:full+, +:human+, +:standard+
    # and +:month+) time formatters.
    def localize(locale, object, format = :default, options = {})
      if format.is_a? Symbol
        key = format
        type = object.respond_to?(:sec) ? 'time' : 'date'
        format = R18n.get[type].formats[key] | format
      end
      R18n.get.localize(object, format)
    end

    # Return array of available locales codes.
    def available_locales
      R18n.get.available_locales.map { |i| i.code.to_sym }
    end

    # Reload R18n I18n object.
    def reload!
      R18n.get.reload!
    end

    protected

    # Find translation by <tt>scope.key(params)</tt> in current R18n I18n
    # object.
    def lookup(scope, key, separator, params)
      keys = (Array(scope) + Array(key)).map { |k|
        k.to_s.split(separator || ::I18n.default_separator) }.flatten
      last = keys.pop

      result = keys.inject(R18n.get) do |node, key|
        if node.is_a? TranslatedString
          node.call(key)
        else
          node[key]
        end
      end

      result = if result.is_a? TranslatedString
        result.call(last)
      else
        result[last, params]
      end

      if result.is_a? TranslatedString
        result.to_s
      elsif result.is_a? Translation
        result.to_hash
      elsif result.is_a? UnpluralizetedHash
        Utils.hash_map(result) do |key, value|
          [Loader::Rails::PLURAL_KEYS.find { |k, v| v == key }.first, value]
        end
      else
        result
      end
    end
  end
end
