# encoding: utf-8
=begin
Locale to i18n support.

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
  # Information about locale (language, country and other special variant
  # preferences). Locale was named by RFC 3066. For example, locale for French
  # speaking people in Canada will be +fr_CA+.
  #
  # Locale files is placed in <tt>locales/</tt> dir in YAML files.
  #
  # Each locale has +sublocales+ – often known languages for people from this
  # locale. For example, many Belorussians know Russian and English. If there
  # is’t translation for Belorussian, it will be searched in Russian and next in
  # English translations.
  #
  # == Usage
  #
  # Get Russian locale and print it information
  #
  #   ru = R18n::Locale.load('ru')
  #   ru.title #=> "Русский"
  #   ru.code  #=> "ru"
  #   ru.ltr?  #=> true
  #
  # == Available data
  #
  # * +code+: locale RFC 3066 code;
  # * +title+: locale name on it language;
  # * +direction+: writing direction, +ltr+ or +rtl+ (for Arabic and Hebrew);
  # * +sublocales+: often known languages for people from this locale;
  # * +include+: locale code to include it data, optional.
  #
  # You can see more available data about locale in samples in
  # <tt>locales/</tt> dir.
  #
  # == Extend locale
  # If language need some special logic (for example, another pluralization or
  # time formatters) you can just change Locale class. Create
  # R18n::Locales::_Code_ class in base/_code_.rb, extend R18n::Locale and
  # rewrite methods (for example, +pluralization+ or +format_date_full+).
  class Locale
    LOCALES_DIR = Pathname(__FILE__).dirname.expand_path + '../../locales/'

    # All available locales
    def self.available
      Dir.glob(File.join(LOCALES_DIR, '*.yml')).map do |i|
        File.basename(i, '.yml')
      end
    end

    # Is +locale+ has info file
    def self.exists?(locale)
      File.exists?(File.join(LOCALES_DIR, locale + '.yml'))
    end

    # Load locale by RFC 3066 +code+
    def self.load(code)
      code = code.to_s
      code.delete! '/'
      code.delete! '\\'
      code.delete! ';'
      original = code
      code = code.downcase
      
      return UnsupportedLocale.new(original) unless exists? code
      
      data = {}
      klass = R18n::Locale
      default_loaded = false
      
      while code and exists? code
        file = LOCALES_DIR + "#{code}.yml"
        default_loaded = true if I18n.default == code
        
        if R18n::Locale == klass and File.exists? LOCALES_DIR + "#{code}.rb"
          require LOCALES_DIR + "#{code}.rb"
          name = code.gsub(/[\w\d]+/) { |i| i.capitalize }.gsub('-', '')
          klass = eval 'R18n::Locales::' + name
        end
        
        loaded = YAML.load_file(file)
        code = loaded['include']
        data = Utils.deep_merge! loaded, data
      end
      
      unless default_loaded
        code = I18n.default
        while code and exists? code
          loaded = YAML.load_file(LOCALES_DIR + "#{code}.yml")
          code = loaded['include']
          data = Utils.deep_merge! loaded, data
        end
      end
      
      klass.new(data)
    end
    
    attr_reader :data

    # Create locale object with locale +data+.
    #
    # This is internal a constructor. To load translation use
    # <tt>R18n::Translation.load(locales, translations_dir)</tt>.
    def initialize(data)
      @data = data
    end
    
    # Locale RFC 3066 code.
    def code
      @data['code']
    end
    
    # Locale title.
    def title
      @data['title']
    end
    
    # Is locale has left-to-right write direction.
    def ltr?
      @data['direction'] == 'ltr'
    end

    # Get information about locale
    def [](name)
      @data[name]
    end

    # Is another locale has same code
    def ==(locale)
      code.downcase == locale.code.downcase
    end
    
    # Is locale has information file. In this class always return true.
    def supported?
      true
    end

    # Human readable locale code and title
    def inspect
      "Locale #{code} (#{title})"
    end
    
    # Convert +object+ to String. It support Fixnum, Bignum, Float, Time, Date
    # and DateTime.
    #
    # For time classes you can set +format+ in standard +strftime+ form,
    # <tt>:full</tt> (“01 Jule, 2009”), <tt>:human</tt> (“yesterday”),
    # <tt>:standard</tt> (“07/01/09”) or <tt>:month</tt> for standalone month
    # name. Default format is <tt>:standard</tt>.
    def localize(obj, i18n = nil, format = nil, *params)
      if obj.is_a? Integer
        format_integer(obj)
      elsif obj.is_a? Float
        format_float(obj)
      elsif i18n and (obj.is_a? Time or obj.is_a? DateTime or obj.is_a? Date)
        if format.is_a? String
          strftime(obj, format)
        else
          if :month == format
            return @data['months']['standalone'][obj.month - 1]
          end
          type = obj.is_a?(Date) ? 'date' : 'time'
          format = :standard unless format
          
          unless [:human, :full, :standard].include? format
            raise ArgumentError, "Unknown time formatter #{format}"
          end
          
          send "format_#{type}_#{format}", i18n, obj, *params
        end
      else
        obj.to_s
      end
    end
    
    # Returns the integer in String form, according to the rules of the locale.
    # It will also put real typographic minus.
    def format_integer(integer)
      str = integer.to_s
      str[0] = '−' if 0 > integer # Real typographic minus
      group = @data['numbers']['group_delimiter']
      
      str.gsub(/(\d)(?=(\d\d\d)+(?!\d))/) do |match|
        match + group
      end
    end
    
    # Returns the float in String form, according to the rules of the locale.
    # It will also put real typographic minus.
    def format_float(float)
      decimal = @data['numbers']['decimal_separator']
      self.format_integer(float.to_i) + decimal + float.to_s.split('.').last
    end
    
    # Same that <tt>Time.strftime</tt>, but translate months and week days
    # names. In +time+ you can use Time, DateTime or Date object. In +format+
    # you can use standard +strftime+ format.
    def strftime(time, format)
      translated = ''
      format.scan(/%[EO]?.|./o) do |c|
        case c.sub(/^%[EO]?(.)$/o, '%\\1')
        when '%A'
          translated << @data['week']['days'][time.wday]
        when '%a'
          translated << @data['week']['abbrs'][time.wday]
        when '%B'
          translated << @data['months']['names'][time.month - 1]
        when '%b'
          translated << @data['months']['abbrs'][time.month - 1]
        when '%p'
          translated << if time.hour < 12
            @data['time']['am']
          else
            @data['time']['pm']
          end
        else
          translated << c
        end
      end
      time.strftime(translated)
    end
    
    # Format +time+ without date. For example, “12:59”.
    def format_time(time)
      strftime(time, @data['time']['time'])
    end
    
    # Format +time+ in human usable form. For example “5 minutes ago” or
    # “yesterday”. In +now+ you can set base time, which be used to get relative
    # time. For special cases you can replace it in locale’s class.
    def format_time_human(i18n, time, now = Time.now)
      minutes = (time - now) / 60.0
      if time.mday != now.mday and minutes.abs > 720 # 12 hours
        format_date_human(i18n, R18n::Utils.to_date(time),
                                R18n::Utils.to_date(now)) + format_time(time)
      else
        case minutes
        when -60..-1
          i18n.human_time.minutes_ago(minutes.round.abs)
        when 1..60
          i18n.human_time.after_minutes(minutes.round)
        when -1..1
          i18n.human_time.now
        else
          hours = (minutes / 60.0).abs.floor
          if time > now
            i18n.human_time.after_hours(hours)
          else
            i18n.human_time.hours_ago(hours)
          end
        end
      end
    end
    
    # Format +time+ in compact form. For example, “12/31/09 12:59”.
    def format_time_standard(i18n, time)
      format_date_standard(i18n, time) + format_time(time)
    end
    
    # Format +time+ in most official form. For example, “December 31st, 2009
    # 12:59”. For special cases you can replace it in locale’s class.
    def format_time_full(i18n, time)
      format_date_full(i18n, time) + format_time(time)
    end
    
    # Format +date+ in human usable form. For example “5 days ago” or
    # “yesterday”. In +now+ you can set base time, which be used to get relative
    # time. For special cases you can replace it in locale’s class.
    def format_date_human(i18n, date, now = Date.today)
      days = (date - now).to_i
      case days
      when -6..-2
        i18n.human_time.days_ago(days.abs)
      when -1
        i18n.human_time.yesterday
      when 0
        i18n.human_time.today
      when 1
        i18n.human_time.tomorrow
      when 2..6
        i18n.human_time.after_days(days)
      else
        format_date_full(i18n, date, date.year != now.year)
      end
    end
    
    # Format +date+ in compact form. For example, “12/31/09”.
    def format_date_standard(i18n, date)
      strftime(date, @data['time']['date'])
    end
    
    # Format +date+ in most official form. For example, “December 31st, 2009”.
    # For special cases you can replace it in locale’s class. If +year+ is false
    # date will be without year.
    def format_date_full(i18n, date, year = true)
      format = @data['time']['full']
      format = @data['time']['year'].sub('_', format) if year
      strftime(date, format)
    end

    # Return pluralization type for +n+ items. This is simple form. For special
    # cases you can replace it in locale’s class.
    def pluralize(n)
      case n
      when 0
        0
      when 1
        1
      else
        'n'
      end
    end
  end
end
