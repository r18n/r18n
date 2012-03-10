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
require 'singleton'

module R18n
  # Information about locale (language, country and other special variant
  # preferences). Locale was named by RFC 3066. For example, locale for French
  # speaking people in Canada will be +fr-CA+.
  #
  # Locale classes are placed in <tt>R18n::Locales</tt> module and storage
  # install <tt>locales/</tt> dir.
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
  # * +code+ – locale RFC 3066 code;
  # * +title+ – locale name on it language;
  # * +ltr?+ – true on left-to-right writing direction, false for Arabic and
  #   Hebrew);
  # * +sublocales+ – often known languages for people from this locale;
  # * +week_start+ – does week start from +:monday+ or +:sunday+.
  #
  # You can see more available data about locale in samples in
  # <tt>locales/</tt> dir.
  class Locale
    LOCALES_DIR = Pathname(__FILE__).dirname.expand_path + '../../locales/'

    @@loaded = {}

    # Codes of all available locales.
    def self.available
      Dir.glob(File.join(LOCALES_DIR, '*.rb')).map do |i|
        File.basename(i, '.rb')
      end
    end

    # Is +locale+ has info file.
    def self.exists?(locale)
      File.exists?(File.join(LOCALES_DIR, locale.to_s + '.rb'))
    end

    # Load locale by RFC 3066 +code+.
    def self.load(code)
      original = code.to_s.gsub(/[^-_a-zA-Z]/, '')
      code = original.gsub('_', '-').downcase

      @@loaded[code] ||= begin
        if exists? code
          require LOCALES_DIR.join("#{code}.rb").to_s
          name = code.gsub(/[\w\d]+/) { |i| i.capitalize }.gsub('-', '')
          eval('R18n::Locales::' + name).new
        else
          UnsupportedLocale.new(original)
        end
      end
    end

    # Set locale +properties+. Locale class will have methods for each propetry
    # name, which return propetry value:
    #
    #   class R18n::Locales::En < R18n::Locale
    #     set :title => 'English',
    #         :code  => 'en'
    #   end
    #
    #   locale = R18n::Locales::En.new
    #   locale.title #=> "English"
    #   locale.code  #=> "en"
    def self.set(properties)
      properties.each_pair do |key, value|
        define_method(key) { value }
      end
    end

    # Locale RFC 3066 code.
    def code
      name = self.class.name.split('::').last
      lang, culture = name.match(/([A-Z][a-z]+)([A-Z]\w+)?/).captures
      lang.downcase + (culture ? '-' + culture.upcase : '')
    end

    set :sublocales => %w{en},
        :week_start => :monday,
        :time_am => 'AM',
        :time_pm => 'PM',
        :time_format => ' %H:%M',
        :full_format => '%e %B',
        :year_format => '_ %Y'

    def month_standalone; month_names; end
    def month_abbrs;      month_names; end

    # Is locale has left-to-right write direction.
    def ltr?; true; end

    # Is another locale has same code.
    def ==(locale)
      self.class == locale.class
    end

    # Is locale has information file. In this class always return true.
    def supported?
      true
    end

    # Human readable locale code and title.
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
    def localize(obj, format = nil, *params)
      case obj
      when Integer
        format_integer(obj)
      when Float
        format_float(obj)
      when Time, DateTime, Date
        return strftime(obj, format) if format.is_a? String
        return month_standalone[obj.month - 1] if :month == format
        return obj.to_s if :human == format and not params.first.is_a? I18n

        type = obj.is_a?(Date) ? 'date' : 'time'
        format = :standard unless format

        unless [:human, :full, :standard].include? format
          raise ArgumentError, "Unknown time formatter #{format}"
        end

        send "format_#{type}_#{format}", obj, *params
      else
        obj.to_s
      end
    end

    # Returns the integer in String form, according to the rules of the locale.
    # It will also put real typographic minus.
    def format_integer(integer)
      str = integer.to_s
      str[0] = '−' if 0 > integer # Real typographic minus
      group = number_group

      str.gsub(/(\d)(?=(\d\d\d)+(?!\d))/) do |match|
        match + group
      end
    end

    # Returns the float in String form, according to the rules of the locale.
    # It will also put real typographic minus.
    def format_float(float)
      decimal = number_decimal
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
          translated << wday_names[time.wday]
        when '%a'
          translated << wday_abbrs[time.wday]
        when '%B'
          translated << month_names[time.month - 1]
        when '%b'
          translated << month_abbrs[time.month - 1]
        when '%p'
          translated << (time.hour < 12 ? time_am : time_pm)
        else
          translated << c
        end
      end
      time.strftime(translated)
    end

    # Format +time+ without date. For example, “12:59”.
    def format_time(time)
      strftime(time, time_format)
    end

    # Format +time+ in human usable form. For example “5 minutes ago” or
    # “yesterday”. In +now+ you can set base time, which be used to get relative
    # time. For special cases you can replace it in locale’s class.
    def format_time_human(time, i18n, now = Time.now, *params)
      minutes = (time - now) / 60.0
      diff = minutes.abs
      if (diff > 24 * 60) or (time.mday != now.mday and diff > 12 * 24)
        format_date_human(R18n::Utils.to_date(time), i18n,
                          R18n::Utils.to_date(now)) + format_time(time)
      else
        if -1 < minutes and 1 > minutes
          i18n.human_time.now
        elsif 60 <= minutes
          i18n.human_time.after_hours((diff / 60.0).floor)
        elsif -60 >= minutes
          i18n.human_time.hours_ago((diff / 60.0).floor)
        elsif 0 < minutes
          i18n.human_time.after_minutes(minutes.round)
        else
          i18n.human_time.minutes_ago(minutes.round.abs)
        end
      end
    end

    # Format +time+ in compact form. For example, “12/31/09 12:59”.
    def format_time_standard(time, *params)
      format_date_standard(time) + format_time(time)
    end

    # Format +time+ in most official form. For example, “December 31st, 2009
    # 12:59”. For special cases you can replace it in locale’s class.
    def format_time_full(time, *params)
      format_date_full(time) + format_time(time)
    end

    # Format +date+ in human usable form. For example “5 days ago” or
    # “yesterday”. In +now+ you can set base time, which be used to get relative
    # time. For special cases you can replace it in locale’s class.
    def format_date_human(date, i18n, now = Date.today, *params)
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
        format_date_full(date, date.year != now.year)
      end
    end

    # Format +date+ in compact form. For example, “12/31/09”.
    def format_date_standard(date, *params)
      strftime(date, date_format)
    end

    # Format +date+ in most official form. For example, “December 31st, 2009”.
    # For special cases you can replace it in locale’s class. If +year+ is false
    # date will be without year.
    def format_date_full(date, year = true, *params)
      format = full_format
      format = year_format.sub('_', format) if year
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

  module Locales; end
end
