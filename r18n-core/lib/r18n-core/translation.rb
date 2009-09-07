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
  #
  # Translation files use YAML format and has name like en.yml (English) or
  # en_US.yml (USA English dialect) with language/country code (RFC 3066). In
  # translation file you can use strings, numbers, floats (any YAML types),
  # procedures (<tt>!!proc</tt>) and pluralizable values (<tt>!!pl</tt>). You
  # can use params in string values, which you can replace in program. Just
  # write <tt>%1</tt>, <tt>%2</tt>, etc and set it values as method arguments,
  # when you will be get value.
  #
  # If in your system procedures in translations willn’t be secure (user can
  # upoad or edit it) set <tt>R18n::Translation.call_proc</tt> to false.
  #
  # To get translation value use method with same name. If translation name
  # is equal with Object methods (+new+, +to_s+, +methods+) use
  # <tt>[name, params…]</tt>. If you want to get pluralizable value, just set
  # value for pluralization in first argument of method. See samples below.
  #
  # Translated strings will have +locale+ methods, which return Locale or it
  # code, if locale file isn’t exists.
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
  #   sum: !!proc |x, y| "is #{x + y}"
  #
  # example.rb
  #
  #   i18n = R18n::Translation.load(['ru', 'en'], 'translations/')
  #   i18n.one   #=> "Один"
  #   i18n.two   #=> "Two"
  #   
  #   i18n.two.locale['code']      #=> "en"
  #   i18n.two.locale['direction'] #=> "ltr"
  #
  #   i18n.entry.between(2, 3)    #=> "between 2 and 3"
  #   i18n['methods', 'object']   #=> "Is object method"
  #   
  #   i18n.comments(0)            #=> "no comments"
  #   i18n.comments(10)           #=> "10 comments"
  #   
  #   i18n.sum(2, 3) #=> "is 5"
  #
  #   i18n.yes    #=> "Yes"
  #   i18n.ok     #=> "OK"
  #   i18n.cancel #=> "Cancel"
  #
  # == Extension translations
  # For r18n plugin you can add dir with translations, which will be used with
  # application translations. For example, DB plugin may place translations for
  # error messages in extension dir. R18n contain translations for base words as
  # extension dir too.
  class Translation
    @@extension_translations = [
      Pathname(__FILE__).dirname.expand_path + '../../base']

    # Get dirs with extension translations. If application translations with
    # same locale isn’t exists, extension file willn’t be used.
    def self.extension_translations
      @@extension_translations
    end
    
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

    # Load all available translations for +locales+. +Locales+ may be a string
    # with one user locale or array with many. +Dirs+ may be an array or
    # a string with path to dir with translations.
    def self.load(locales, dirs)
      locales = Array(locales) & self.available(dirs)
      dirs = @@extension_translations + Array(dirs)
      
      translations = []
      locales.map! do |locale|
        translation = {}
        dirs.each do |dir|
          file = File.join(dir, "#{locale}.yml")
          if File.exists? file
            Utils.deep_merge! translation, YAML::load_file(file)
          end
        end
        translations << translation
        
        Locale.load(locale)
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
      
      return Untranslated.new(path, name)
    end
  end
end
