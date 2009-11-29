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
require 'yaml'

module R18n
  # Translation for interface to i18n support. You can load several locales and
  # if translation willn’t be found in first, r18n will be search it in next.
  # Use R18n::I18n.new to load translations.
  #
  # Translation files use YAML format and has name like en.yml (English) or
  # en-US.yml (USA English dialect) with language/country code (RFC 3066). In
  # translation file you can use strings, numbers, floats (any YAML types)
  # and pluralizable values (<tt>!!pl</tt>). You can use params in string
  # values, which you can replace in program. Just write <tt>%1</tt>,
  # <tt>%2</tt>, etc and set it values as method arguments, when you will be get
  # value.
  #
  # You can use filters for some YAML type or for all strings. See R18n::Filters
  # for details.
  #
  # To get translation value use method with same name. If translation name
  # is equal with Object methods (+new+, +to_s+, +methods+) use
  # <tt>[name, params…]</tt>. If you want to get pluralizable value, just set
  # value for pluralization in first argument of method. See samples below.
  #
  # Translated strings will have +locale+ methods, which return Locale or
  # UnsupportedLocale, if locale file isn’t exists.
  #
  # R18n contain translations for common words (such as “OK”, “Cancel”, etc)
  # for most supported locales. See <tt>base/</tt> dir.
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
  #   locales = [R18n::Locale.load('ru'), R18n::Locale.load('en')]
  #   i18n = R18n::Translation.load(locales, 'translations/')
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
  #
  #   i18n.yes    #=> "Yes"
  #   i18n.ok     #=> "OK"
  #   i18n.cancel #=> "Cancel"
  class Translation
    # Return available translations in +dirs+
    def self.available(dirs)
      if dirs.is_a? Array
        return dirs.inject([]) do |available, i|
          available |= self.available(i)
        end
      end
      
      Dir.glob(File.join(dirs, '*.yml')).map do |i|
        File.basename(i, '.yml')
      end
    end

    # Load all available translations for +locales+. +Locales+ must be Locale or
    # UnsupportedLocale instance or an array them. +Dirs+ may be an array or a
    # string with path to dir with translations.
    # 
    # To load translations use R18n::I18n.new method, which is more usable.
    def self.load(locales, dirs)
      dirs = R18n.extension_translations + Array(dirs)
      
      available = self.available(dirs)
      translations = []
      locales.each do |locale|
        next unless available.include? locale.code.downcase
        translation = {}
        dirs.each do |dir|
          file = File.join(dir, "#{locale.code.downcase}.yml")
          if File.exists? file
            Utils.deep_merge! translation, YAML::load_file(file)
          end
        end
        translations << translation
      end
  
      self.new(locales, translations)
    end
    
    # Create translation hash for +path+ with messages in +translations+ for
    # +locales+.
    #
    # This is internal a constructor. To load translation use
    # <tt>R18n::Translation.load(locales, translations_dir)</tt>.
    def initialize(locales, translations, path = '')
      @locales = locales
      @translations = translations
      @path = path
    end
    
    # Short and pretty way to get translation by method name. If translation
    # has name like object methods (+new+, +to_s+, +methods+) use <tt>[]</tt>
    # method to access.
    #
    # Translation can contain variable part. Just set is as <tt>%1</tt>,
    # <tt>%2</tt>, etc in translations file and set values as methods params.
    def method_missing(name, *params)
      self[name.to_s, *params]
    end
    
    # Return translation with special +name+.
    #
    # Translation can contain variable part. Just set is as <tt>%1</tt>,
    # <tt>%2</tt>, etc in translations file and set values in next +params+.
    def [](name, *params)
      path = @path.empty? ? name : "#{@path}.#{name}"
      
      @translations.each_with_index do |translation, i|
        result = translation[name]
        next unless result
        
        if result.is_a? Hash
          return self.class.new(@locales, @translations.map { |i|
            i[name] or {}
          }, path)
        elsif result.is_a? YAML::PrivateType
          type = result.type_id
          result = result.value
        else
          type = nil
        end
        
         return Filters.process(result, @locales[i], path, type, params)
      end
      
      Untranslated.new(path, name, @locales)
    end
  end
end
