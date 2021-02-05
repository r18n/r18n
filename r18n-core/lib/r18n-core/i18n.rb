# frozen_string_literal: true

# I18n support.
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

require 'date'

module R18n
  # General class to i18n support in your application. It load Translation and
  # Locale classes and create pretty way to use it.
  #
  # To get translation you can use same with Translation way – use method with
  # translation's name or `[name]` method. Translations will be also
  # loaded for default locale, `sublocales` from first in `locales` and general
  # languages for dialects (it will load `fr` for `fr_CA` too).
  #
  # Translations will loaded by loader object, which must have 2 methods:
  # * `available` – return array of locales of available translations;
  # * `load(locale)` – return Hash of translation.
  # If you will use default loader (`R18n.default_loader`) you can pass to I18n
  # only constructor argument for loader:
  #
  #   R18n::I18n.new('en', R18n::Loader::YAML.new('dir/with/translations'))
  #
  # is a same as:
  #
  #   R18n::I18n.new('en', 'dir/with/translations')
  #
  # In translation file you can use strings, numbers, floats (any YAML types)
  # and pluralizable values (`!!pl`). You can use params in string
  # values, which you can replace in program. Just write `%1`,
  # `%2`, etc and set it values as method arguments, when you will be get
  # value.
  #
  # You can use filters for some YAML type or for all strings. See R18n::Filters
  # for details.
  #
  # R18n contain translations for common words (such as "OK", "Cancel", etc)
  # for most supported locales. See `base/` dir.
  #
  # == Usage
  # translations/ru.yml
  #
  #   one: Один
  #
  # translations/en.yml
  #
  #   one: One
  #   two: Two
  #
  # example.rb
  #
  #   i18n = R18n::I18n.new(['ru', 'en'], 'translations/')
  #
  #   i18n.one   #=> "Один"
  #   i18n.two   #=> "Two"
  #
  #   i18n.locale.title        #=> "Русский"
  #   i18n.locale.code         #=> "ru"
  #   i18n.locale.ltr?         #=> true
  #
  #   i18n.l -11000.5          #=> "−11 000,5"
  #   i18n.l Time.now          #=> "Вск, 21 сен 2008, 22:10:10 MSD"
  #   i18n.l Time.now, :date   #=> "21.09.2008"
  #   i18n.l Time.now, :time   #=> "22:10"
  #   i18n.l Time.now, '%A'    #=> "Воскресенье"
  #
  #   i18n.yes    #=> "Yes"
  #   i18n.ok     #=> "OK"
  #   i18n.cancel #=> "Cancel"
  class I18n
    @default = 'en'

    class << self
      attr_accessor :default

      # Parse HTTP_ACCEPT_LANGUAGE and return array of user locales
      def parse_http(str)
        return [] if str.nil?

        locales = str.split(',')
        locales.map! do |locale|
          locale = locale.split ';q='
          if locale.size == 1
            [locale[0], 1.0]
          else
            [locale[0], locale[1].to_f]
          end
        end
        locales.sort! { |a, b| b[1] <=> a[1] }
        locales.map! { |i| i[0] }
      end

      # Load default loader for elements in `places` with only constructor
      # argument.
      def convert_places(places)
        Array(places).map! do |loader|
          if loader.respond_to?(:available) && loader.respond_to?(:load)
            loader
          else
            R18n.default_loader.new(loader)
          end
        end
      end
    end

    # User locales, ordered by priority
    attr_reader :locales

    # Loaders with translations files
    attr_reader :translation_places

    # First locale with locale file
    attr_reader :locale

    # Create i18n for `locales` with translations from `translation_places` and
    # locales data. Translations will be also loaded for default locale,
    # `sublocales` from first in `locales` and general languages for dialects
    # (it will load `fr` for `fr_CA` too).
    #
    # `locales` must be a locale code (RFC 3066) or array, ordered by priority.
    # `translation_places` must be a string with path or array.
    def initialize(locales, translation_places = nil, opts = {})
      locales = Array(locales)

      locales.each_with_index do |locale, i|
        locales.insert(i + 1, locale.match(/([^_-]+)[_-]/)[1]) if locale.match?(/[^_-]+[_-]/)
        locales.insert(i + 1, *(Locale.load(locale).sublocales - locales)) if Locale.exists?(locale)
      end
      locales << self.class.default
      locales.map! { |i| i.to_s.downcase }.uniq!
      @locales_codes = locales
      @locales = locales.each_with_object([]) do |locale, result|
        locale = Locale.load(locale)
        next unless locale

        result << locale
      end

      if translation_places
        @original_places = translation_places
      else
        @original_places = R18n.extension_places
        @locale = @locales.first
      end

      @translation_places = self.class.convert_places(@original_places)

      @filters =
        if opts[:on_filters] || opts[:off_filters]
          CustomFilterList.new(opts[:on_filters], opts[:off_filters])
        else
          GlobalFilterList.instance
        end

      key = translation_cache_key
      if R18n.cache.key? key
        @locale, @translation = *R18n.cache[key]
      else
        reload!
      end
    end

    # Return custom filters list
    def filter_list
      @filters
    end

    # Return unique key for current locales in translation and places.
    def translation_cache_key
      @available_codes ||= @translation_places
        .inject([]) { |all, i| all + i.available }
        .uniq.map { |i| i.code.downcase }
      "#{(@locales_codes & @available_codes).join(',')}@" \
        "#{@filters.hash}_#{R18n.default_loader.hash}_#{@translation_places.hash}_" +
        R18n.extension_places.hash.to_s
    end

    # Reload translations.
    def reload!
      @available_locales = @available_codes = nil
      @translation_places = self.class.convert_places(@original_places)

      available_in_places = @translation_places.map { |i| [i, i.available] }
      available_in_extensions =
        R18n.extension_places.map { |i| [i, i.available] }

      unless defined? @locale
        available_in_places.each do |_place, available|
          @locales.each do |locale|
            if available.include? locale
              @locale = locale
              break
            end
          end
          break if defined? @locale
        end
      end
      @locale ||= @locales.first
      unless @locale.supported?
        @locales.each do |locale|
          if locale.supported?
            @locale.base = locale
            break
          end
        end
      end

      @translation = Translation.new(@locale, '', filters: @filters)
      @locales.each do |locale|
        loaded = false

        available_in_places.each do |place, available|
          if available.include? locale
            @translation.merge! place.load(locale), locale
            loaded = true
          end
        end

        next unless loaded

        available_in_extensions.each do |extension, available|
          @translation.merge! extension.load(locale), locale if available.include? locale

          if available.include? locale.parent
            @translation.merge! extension.load(locale.parent), locale.parent
          end
        end
      end

      R18n.cache[translation_cache_key] = [@locale, @translation]
    end

    # Return `Array` of locales with available translations.
    def available_locales
      @available_locales ||= R18n.available_locales(@translation_places)
    end

    # Convert `object` to `String`, according to the rules of the current
    # locale. It support `Integer`, `Float`, `Time`, `Date` and `DateTime`.
    #
    # For time classes you can set `format` in standard `strftime` form,
    # `:full` ("01 Jule, 2009"), `:human` ("yesterday"),
    # `:standard` ("07/01/09") or `:month` for standalone month
    # name. Default format is `:standard`.
    #
    #   i18n.l -12000.5         #=> "−12,000.5"
    #   i18n.l Time.now         #=> "07/01/09 12:59"
    #   i18n.l Time.now.to_date #=> "07/01/09"
    #   i18n.l Time.now, :human #=> "now"
    #   i18n.l Time.now, :full  #=> "Jule 1st, 2009 12:59"
    def localize(object, format = nil, **kwargs)
      locale.localize(object, format, i18n: self, **kwargs)
    end
    alias l localize

    # Return translations.
    def t
      @translation
    end

    # Return translation with special `name`.
    #
    # Translation can contain variable part. Just set is as `%1`,
    # `%2`, etc in translations file and set values in next `params`.
    def [](name, *params)
      @translation[name, *params]
    end
    alias method_missing []
  end
end
