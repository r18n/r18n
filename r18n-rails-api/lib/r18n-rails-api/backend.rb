# frozen_string_literal: true

# R18n backend for Rails I18n.
#
# Copyright (C) 2009 Andrey “A.I.” Sitnik <andrey@sitnik.ru>
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

require 'i18n/backend/transliterator'

module R18n
  # R18n backend for Rails I18n. You must set R18n I18n object before use this
  # backend:
  #
  #   R18n.set locales, R18n::Loader::Rails
  #
  #   I18n.l Time.now, format: :full #=> "6th of December, 2009 22:44"
  class Backend
    include ::I18n::Backend::Transliterator

    RESERVED_KEYS = %i[scope default separator].freeze

    # Find translation in R18n. It didn't use `locale` argument, only current
    # R18n I18n object. Also it doesn't support `Proc` and variables in
    # `default` String option.
    def translate(locale, key, options = {})
      return key.map { |k| translate(locale, k, options) } if key.is_a?(Array)

      scope, default, separator = options.values_at(*RESERVED_KEYS)
      params = options.reject { |name, _value| RESERVED_KEYS.include?(name) }

      result = lookup(locale, scope, key, separator, params)

      if result.is_a? Untranslated
        options = options.reject { |opts_key, _value| opts_key == :default }

        default = []        if default.nil?
        default = [default] unless default.is_a? Array

        default.each do |entry|
          if entry.is_a? Symbol
            value = lookup(locale, scope, entry, separator, params)
            return value unless value.is_a? Untranslated
          elsif entry.is_a? Proc
            proc_key = options.delete(:object) || key
            return entry.call(proc_key, options)
          else
            return entry
          end
        end

        raise ::I18n::MissingTranslationData.new(locale, key, options)
      else
        result
      end
    end

    # Convert `object` to `String`, according to the rules of the current
    # R18n locale. It didn't use `locale` argument, only current R18n I18n
    # object. It support `Integer`, `Float`, `Time`, `Date` and `DateTime`.
    #
    # Support Rails I18n (`:default`, `:short`, `:long`, `:long_ordinal`,
    # `:only_day` and `:only_second`) and R18n (`:full`, `:human`, `:standard`
    # and `:month`) time formatters.
    def localize(locale, object, format = :default, _options = {})
      i18n = get_i18n(locale)
      if format.is_a? Symbol
        key  = format
        type = object.respond_to?(:sec) ? 'time' : 'date'
        format = i18n[type].formats[key] | format
      end
      i18n.localize(object, format)
    end

    # Return array of available locales codes.
    def available_locales
      R18n.available_locales.map { |i| i.code.to_sym }
    end

    # Reload R18n I18n object.
    def reload!
      R18n.get.reload!
    end

    protected

    def get_i18n(locale)
      i18n = R18n.get
      i18n = R18n.change(locale.to_s) if i18n.locale.code != locale.to_s
      i18n
    end

    def format_value(result)
      if result.is_a? TranslatedString
        result.to_s
      elsif result.is_a? UnpluralizetedTranslation
        result.to_hash.map { |k, v| [RailsPlural.from_r18n(k), v] }.to_h
      elsif result.is_a? Translation
        translation_to_hash(result)
      else
        result
      end
    end

    def translation_to_hash(translation)
      translation.to_hash.map do |key, value|
        [
          key.to_sym,
          value.is_a?(Hash) ? translation_to_hash(value) : format_value(value)
        ]
      end.to_h
    end

    # Find translation by `scope.key(params)` in current R18n I18n
    # object.
    def lookup(locale, scope, key, separator, params)
      keys = (Array(scope) + Array(key))
        .map { |k| k.to_s.split(separator || ::I18n.default_separator) }
        .flatten
      last = keys.pop.to_sym

      result = keys.inject(get_i18n(locale).t) do |node, iterated_key|
        if node.is_a? TranslatedString
          node.get_untranslated(iterated_key)
        else
          node[iterated_key]
        end
      end

      result =
        if result.is_a? TranslatedString
          result.get_untranslated(key)
        else
          result[last, params]
        end

      format_value(result)
    end
  end
end
