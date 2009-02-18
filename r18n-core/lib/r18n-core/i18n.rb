# encoding: utf-8
=begin
I18n support.

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

require 'date'

module R18n
  # General class to i18n support in your application. It load Translation and
  # Locale classes and create pretty way to use it.
  #
  # To get translation you can use same with Translation way – use method with
  # translation’s name or <tt>[name]</tt> method. Translations will be also
  # loaded for default locale, +sublocales+ from first in +locales+ and general
  # languages for dialects (it will load +fr+ for +fr_CA+ too).
  #
  # See Translation and Locale documentation.
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
  #   i18n.locale['title']     #=> "Русский"
  #   i18n.locale['code']      #=> "ru"
  #   i18n.locale['direction'] #=> "ltr"
  #   
  #   i18n.l -11000.5          #=> "−11 000,5"
  #   i18n.l Time.now          #=> "Вск, 21 сен 2008, 22:10:10 MSD"
  #   i18n.l Time.now, :date   #=> "21.09.2008"
  #   i18n.l Time.now, :time   #=> "22:10"
  #   i18n.l Time.now, '%A'    #=> "Воскресенье"
  class I18n
    @@default = 'en'

    # Set default locale code to use when any user locales willn't be founded.
    # It should has all translations and locale file.
    def self.default=(locale)
      @@default = locale
    end

    # Get default locale code
    def self.default
      @@default
    end
    
    # Parse HTTP_ACCEPT_LANGUAGE and return array of user locales
    def self.parse_http(str)
      return [] if str.nil?
      locales = str.split(',')
      locales.map! do |locale|
        locale = locale.split ';q='
        if 1 == locale.size
          [locale[0], 1.0]
        else
          [locale[0], locale[1].to_f]
        end
      end
      locales.sort! { |a, b| b[1] <=> a[1] }
      locales.map! { |i| i[0] }
    end
    
    # User locales, ordered by priority
    attr_reader :locales
    
    # Dirs with translations files
    attr_reader :translations_dirs
    
    # First locale with locale file
    attr_reader :locale
    
    # Create i18n for +locales+ with translations from +translations_dirs+ and
    # locales data. Translations will be also loaded for default locale,
    # +sublocales+ from first in +locales+ and general languages for dialects
    # (it will load +fr+ for +fr_CA+ too).
    #
    # +Locales+ must be a locale code (RFC 3066) or array, ordered by priority.
    # +Translations_dirs+ must be a string with path or array.
    def initialize(locales, translations_dirs = nil)
      locales = [locales] if String == locales.class
      
      @locales = locales.map do |locale|
        if Locale.exists? locale
          Locale.load(locale)
        else
          locale
        end
      end
      
      locales << @@default
      if @locales.first.kind_of? Locale
        locales += @locales.first['sublocales']
      end
      locales.each_with_index do |locale, i|
        if "_" == locale[2..2]
          locales.insert(i + 1, locale[0..1])
        end
      end
      locales.uniq!
      
      locales.each do |locale|
        if Locale.exists? locale
          @locale = Locale.load(locale)
          break
        end
      end
      
      if not translations_dirs.nil?
        @translations_dirs = translations_dirs
        @translation = Translation.load(locales, @translations_dirs)
      end
    end
    
    # Return Hash with titles (or code for translation without locale file) of
    # available translations.
    def translations
      Translation.available(@translations_dirs).inject({}) do |all, code|
        all[code] = if Locale.exists? code
          Locale.load(code)['title']
        else
          code
        end
        all
      end
    end
    
    # Convert +object+ to String, according to the rules of the current locale.
    # It support Fixnum, Bignum, Float, Time, Date and DateTime.
    #
    # For time classes you can set +format+ in standart +strftime+ form, or
    # Symbol to use format from locale file (<tt>:time</tt>, <tt>:date</tt>,
    # <tt>:short_data</tt>, <tt>:long_data</tt>, <tt>:datetime</tt>,
    # <tt>:short_datetime</tt> or <tt>:long_datetime</tt>). Without format it
    # use <tt>:datetime</tt> for Time and DateTime and <tt>:date</tt> for Date.
    def localize(object, format = nil)
      if Fixnum == object.class or Bignum == object.class
        locale.format_number(object)
      elsif Float == object.class
        locale.format_float(object)
      elsif Time == object.class or DateTime == object.class
        format = :datetime if format.nil?
        locale.strftime(object, format)
      elsif Date == object.class
        format = :date if format.nil?
        locale.strftime(object, format)
      end
    end
    alias :l :localize
    
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
      @translation[name, *params]
    end
  end
end
