# frozen_string_literal: true

# Main file to load all neccessary classes for i18n support.
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

%w[
  version
  utils
  locale
  unsupported_locale
  translated_string
  untranslated
  translation
  filters
  filter_list
  yaml_methods
  yaml_loader
  i18n
  helpers
].each do |file|
  require_relative File.join('r18n-core', file)
end

module R18n
  autoload :Translated, 'r18n-core/translated'

  class << self
    # Set I18n object globally. You can miss translation `places`, it will be
    # taken from `R18n.default_places`.
    def set(i18n = nil, places = R18n.default_places, &block)
      @i18n =
        if block_given?
          @setter = block
          nil
        elsif i18n.is_a? I18n
          i18n
        else
          I18n.new(i18n, places)
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
      self.cache = {}
    end

    # Delete I18n object from current thread and global variable.
    def reset!
      thread[:r18n_i18n] = thread[:r18n_setter] = @i18n = @setter = nil
      clear_cache!
    end

    # Deprecated.
    alias reset reset!

    # Get the current thread.
    def thread
      Thread.current
    end

    # Translate message. Alias for `R18n.get.t`.
    def t(*params)
      get.t(*params)
    end

    # Localize object. Alias for `R18n.get.l`.
    def l(*params)
      get.l(*params)
    end

    # Return I18n object for `locale`. Useful to temporary change locale,
    # for example, to show text in locales list:
    #
    #   - R18n.available_locales.each do |locale|
    #     - R18n.change(locale).t.language_title
    #
    # It also can be used with block:
    #
    #   - R18n.change(locale) { t.language_title }
    def change(locale)
      locale = locale.code if locale.is_a? Locale
      exists = get ? get.locales.map(&:code) : []
      places = get ? get.translation_places : R18n.default_places

      i18n = R18n::I18n.new([locale] + exists, places)

      if block_given?
        old_thread_i18n = thread[:r18n_i18n]
        thread_set i18n
        yield
        thread[:r18n_i18n] = old_thread_i18n
      end

      i18n
    end

    # Return Locale object by locale code. It's shortcut for
    # `R18n::Locale.load(code)`.
    def locale(code)
      R18n::Locale.load(code)
    end

    # Return `Array` of locales with available translations. You can miss
    # translation `places`, it will be taken from `R18n.default_places`.
    def available_locales(places = R18n.default_places)
      R18n::I18n.convert_places(places).map(&:available).flatten.uniq
    end

    # Default places for `R18n.set` and `R18n.available_locales`.
    #
    # You can set block to calculate places dynamically:
    #   R18n.default_places { settings.i18n_places }
    attr_writer :default_places

    def default_places(&block)
      if block_given?
        @default_places = block
      elsif @default_places.is_a? Proc
        @default_places.call
      else
        @default_places
      end
    end

    # Default loader class, which will be used if you didn't send loader to
    # `I18n.new` (object with `available` and `load` methods).
    attr_accessor :default_loader

    # Loaders with extension translations. If application translations with
    # same locale isn't exists, extension file willn't be used.
    attr_accessor :extension_places

    # `Hash` of hash-like (see Moneta) object to store loaded translations.
    attr_accessor :cache
  end

  self.default_loader   = R18n::Loader::YAML
  self.default_places   = nil
  self.extension_places = [Loader::YAML.new(File.join(__dir__, '..', 'base'))]
  clear_cache!
end
