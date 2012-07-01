# encoding: utf-8
=begin
Translation to i18n support.

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

require 'pathname'

module R18n
  # Struct to containt translation with some type for filter.
  Typed = Struct.new(:type, :value, :locale, :path)

  # Translation is container of translated messages.
  #
  # You can load several locales and if translation willn’t be found in first,
  # r18n will be search it in next. Use R18n::I18n.new to load translations.
  #
  # To get translation value use method with same name. If translation name
  # is equal with Object methods (+new+, +to_s+, +methods+) use
  # <tt>[name, params…]</tt>. If you want to get pluralizable value, just set
  # value for pluralization in first argument of method. See samples below.
  #
  # Translated strings will have +locale+ methods, which return Locale or
  # UnsupportedLocale, if locale file isn’t exists.
  #
  # == Examples
  # translations/ru.yml
  #
  #   one: Один
  #
  # translations/en.yml
  #
  #   one: One
  #   two: Two
  #
  #   entry:
  #     between: Between %1 and %2
  #   methods: Is %1 method
  #
  #   comments: !!pl
  #     0: no comments
  #     1: one comment
  #     n: %1 comments
  #
  # example.rb
  #
  #   i18n.one   #=> "Один"
  #   i18n.two   #=> "Two"
  #
  #   i18n.two.locale.code      #=> "en"
  #   i18n.two.locale.ltr?      #=> "ltr"
  #
  #   i18n.entry.between(2, 3)    #=> "between 2 and 3"
  #   i18n['methods', 'object']   #=> "Is object method"
  #
  #   i18n.comments(0)            #=> "no comments"
  #   i18n.comments(10)           #=> "10 comments"
  class Translation
    # This is internal a constructor. To load translation use
    # <tt>R18n::I18n.new(locales, translations_dir)</tt>.
    def initialize(locale, path = '', options = {})
      @data    = {}
      @locale  = locale
      @path    = path
      @filters = options[:filters] || GlobalFilterList.instance

      merge! options[:translations], options[:locale] if options[:translations]
    end

    # Add another hash with +translations+ for some +locale+. Current data is
    # more priority, that new one in +translations+.
    def merge!(translations, locale)
      translations.each_pair do |name, value|
        if not @data.has_key? name
          path = @path.empty? ? name : "#{@path}.#{name}"
          case value
          when Hash
            value = Translation.new(@locale, path,
              :locale => locale, :translations => value, :filters => @filters)
          when String
            c = { :locale => locale, :path => path }
            v = @filters.process_string(:passive, value, c, [])
            value = TranslatedString.new(v, locale, path, @filters)
          when Typed
            value.locale = locale
            value.path   = path
            unless @filters.passive(value.type).empty?
              value = @filters.process_typed(:passive, value, { })
            end
          end
          @data[name] = value
        elsif @data[name].is_a? Translation
          @data[name].merge! value, locale
        end
      end
    end

    # Use untranslated filter to print path.
    def to_s
      @filters.process(:all, Untranslated, @path, @locale, @path,
                      [@path, '', @path])
    end

    # Return current translation keys.
    #
    # Deprecated. Use <tt>to_hash.keys</tt>.
    def translation_keys
      to_hash.keys
    end

    # Return hash of current translation node.
    def to_hash
      Utils.hash_map(@data) do |key, node|
        node = node.to_hash if hode.is_a? Translation
        [key, node]
      end
    end

    # Return +default+.
    def |(default)
      default
    end

    # Return translation with special +name+.
    #
    # Translation can contain variable part. Just set is as <tt>%1</tt>,
    # <tt>%2</tt>, etc in translations file and set values in next +params+.
    def [](name, *params)
      value = @data[name.to_s]
      case value
      when TranslatedString
        @filters.process_string(:active, value, @path, params)
      when Typed
        @filters.process_typed(:active, value, params)
      when nil
        translated = @path.empty? ? '' : "#{@path}."
        Untranslated.new(translated, name.to_s, @locale, @filters)
      else
        value
      end
    end
    alias method_missing []
  end
end
