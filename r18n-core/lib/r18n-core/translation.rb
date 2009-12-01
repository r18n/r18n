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
    
    # Use untranslated filter to print path.
    def to_s
      config = OpenStruct.new(:locale  => @locales.first, :path => @path,
                              :locales => @locales)
      Filters.enabled[Untranslated].inject(@path) do |string, filter|
        filter.call(string, config, @path, '', @path)
      end
    end
    
    # Short and pretty way to get translation by method name. If translation
    # has name like object methods (+new+, +to_s+, +methods+) use <tt>[]</tt>
    # method to access.
    #
    # Translation can contain variable part. Just set is as <tt>%1</tt>,
    # <tt>%2</tt>, etc in translations file and set values as methods params.
    def method_missing(name, *params)
      self[name, *params]
    end
    
    # Return translation with special +name+.
    #
    # Translation can contain variable part. Just set is as <tt>%1</tt>,
    # <tt>%2</tt>, etc in translations file and set values in next +params+.
    def [](name, *params)
      name = name.to_s
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
