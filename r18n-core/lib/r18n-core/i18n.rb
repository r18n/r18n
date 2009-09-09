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
  #   i18n.locale.title        #=> "Русский"
  #   i18n.locale.code         #=> "ru"
  #   i18n.locale.ltr?         #=> true
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
    attr_reader :translation_dirs
    
    # First locale with locale file
    attr_reader :locale
    
    # Create i18n for +locales+ with translations from +translation_dirs+ and
    # locales data. Translations will be also loaded for default locale,
    # +sublocales+ from first in +locales+ and general languages for dialects
    # (it will load +fr+ for +fr_CA+ too).
    #
    # +Locales+ must be a locale code (RFC 3066) or array, ordered by priority.
    # +Translation_dirs+ must be a string with path or array.
    def initialize(locales, translation_dirs = nil)
      locales = [locales] if locales.is_a? String
      
      if not locales.empty? and Locale.exists? locales.first
        locales += Locale.load(locales.first)['sublocales']
      end
      locales << @@default
      locales.each_with_index do |locale, i|
        if "_" == locale[2..2]
          locales.insert(i + 1, locale[0..1])
        end
      end
      locales.uniq!
      
      if translation_dirs.nil?
        @translation_dirs = []
        @translation = Translation.load(locales,
                                        Translation.extension_translations)
      else
        @translation_dirs = translation_dirs
        @translation = Translation.load(locales, @translation_dirs)
      end
      
      @locales = locales.map { |i| Locale.load(i) }
      @locale = @locales.first
      unless @locale.supported?
        @locales.each do |locale|
          if locale.supported?
            @locale.base = locale
            break
          end
        end
      end
    end
    
    # Return Hash with titles (or code for unsupported locales) for available
    # translations.
    def translations
      Translation.available(@translation_dirs).inject({}) do |all, code|
        all[code] = Locale.load(code).title
        all
      end
    end
    
    # Convert +object+ to String, according to the rules of the current locale.
    # It support Fixnum, Bignum, Float, Time, Date and DateTime.
    #
    # For time classes you can set +format+ in standard +strftime+ form,
    # <tt>:full</tt> (“01 Jule, 2009”), <tt>:human</tt> (“yesterday”),
    # <tt>:standard</tt> (“07/01/09”) or <tt>:month</tt> for standalone month
    # name. Default format is <tt>:standard</tt>.
    #
    #   i18n.l -12000.5         #=> "−12,000.5"
    #   i18n.l Time.now         #=> "07/01/09 12:59"
    #   i18n.l Time.now.to_date #=> "07/01/09"
    #   i18n.l Time.now, :human #=> "now"
    #   i18n.l Time.now, :full  #=> "Jule 1st, 2009 12:59"
    def localize(object, format = nil, *params)
      if object.is_a? Integer
        locale.format_integer(object)
      elsif object.is_a? Float
        locale.format_float(object)
      elsif object.is_a? Time or object.is_a? DateTime or object.is_a? Date
        if format.is_a? String
          locale.strftime(object, format)
        else
          if :month == format
            return locale.data['months']['standalone'][object.month - 1]
          end
          type = object.is_a?(Date) ? 'date' : 'time'
          format = :standard unless format
          
          unless [:human, :full, :standard].include? format
            raise ArgumentError, "Unknown time formatter #{format}"
          end
          
          locale.send "format_#{type}_#{format}", self, object, *params
        end
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
      @translation[name.to_s, *params]
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
