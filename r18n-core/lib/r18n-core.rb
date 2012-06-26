# encoding: utf-8
=begin
Main file to load all neccessary classes for i18n support.

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

$KCODE = 'u' if '1.8.' == RUBY_VERSION[0..3]

require 'pathname'

dir = Pathname(__FILE__).dirname.expand_path + 'r18n-core'
require dir.join('version').to_s
require dir.join('utils').to_s
require dir.join('locale').to_s
require dir.join('unsupported_locale').to_s
require dir.join('translated_string').to_s
require dir.join('untranslated').to_s
require dir.join('filters').to_s
require dir.join('filter_list').to_s
require dir.join('translation').to_s
require dir.join('yaml_loader').to_s
require dir.join('i18n').to_s
require dir.join('helpers').to_s

module R18n
  autoload :Translated, 'r18n-core/translated'

  class << self

    # Set I18n object globally. You can miss translation +places+, it will be
    # taken from <tt>R18n.default_places</tt>.
    def set(i18n = nil, places = R18n.default_places, &block)
      if block_given?
        @setter = block
        @i18n   = nil
      elsif i18n.is_a? I18n
        @i18n = i18n
      else
        @i18n = I18n.new(i18n, places)
      end
    end

    # Set I18n object to current thread.
    def thread_set(i18n = nil, &block)
      if block_given?
        thread[:r18n_setter] = block
        thread[:r18n_i18n]   = nil
      else
        thread[:r18n_i18n] = i18n
      end
    end

    # Get I18n object for current thread.
    def get
      thread[:r18n_i18n] ||
      (thread[:r18n_setter] && thread_set(thread[:r18n_setter].call)) ||
      @i18n ||
      (@setter && set(@setter.call))
    end

    # Clean translations cache.
    def clear_cache!
      self.cache = { }
    end

    # Delete I18n object from current thread and global variable.
    def reset!
      thread[:r18n_i18n] = thread[:r18n_setter] = @i18n = @setter = nil
      clear_cache!
    end
    alias :reset :reset!

    # Get the current thread.
    def thread
      Thread.current
    end

    # Translate message. Alias for <tt>R18n.get.t</tt>.
    def t(*params)
      get.t(*params)
    end

    # Localize object. Alias for <tt>R18n.get.l</tt>.
    def l(*params)
      get.l(*params)
    end

    # Return I18n object for +locale+. Useful to temporary change locale,
    # for example, to show text in locales list:
    #
    #   - R18n.available_locales.each do |locale|
    #     - R18n.change(locale).t.language_title
    def change(locale)
      locale = locale.code if locale.is_a? Locale
      exists = get ? get.locales.map { |i| i.code } : []
      places = get ? get.translation_places : R18n.default_places
      R18n::I18n.new([locale] + exists, places)
    end

    # Return Locale object by locale code. It’s shortcut for
    # <tt>R18n::Locale.load(code)</tt>.
    def locale(code)
      R18n::Locale.load(code)
    end

    # Return Array of locales with available translations. You can miss
    # translation +places+, it will be taken from <tt>R18n.default_places</tt>.
    def available_locales(places = R18n.default_places)
      R18n::I18n.convert_places(places).map { |i| i.available }.flatten.uniq
    end

    # Default places for <tt>R18n.set</tt> and <tt>R18n.available_locales</tt>.
    #
    # You can set block to calculate places dynamically:
    #   R18n.default_places { settings.i18n_places }
    attr_accessor :default_places

    def default_places(&block)
      if block_given?
        @default_places = block
      elsif @default_places.is_a? Proc
        @default_places.call
      else
        @default_places
      end
    end

    # Default loader class, which will be used if you didn’t send loader to
    # +I18n.new+ (object with +available+ and +load+ methods).
    attr_accessor :default_loader

    # Loaders with extension translations. If application translations with
    # same locale isn’t exists, extension file willn’t be used.
    attr_accessor :extension_places

    # Hash of hash-like (see Moneta) object to store loaded translations.
    attr_accessor :cache
  end

  dir = Pathname(__FILE__).dirname.expand_path
  self.default_loader   = R18n::Loader::YAML
  self.default_places   = nil
  self.extension_places = [Loader::YAML.new(dir + '../base')]
  self.clear_cache!
end
