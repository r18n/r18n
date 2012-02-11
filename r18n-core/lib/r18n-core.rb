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

    # Set I18n object globally.
    def set(i18n = nil, dir = nil, &block)
      if block_given?
        @setter = block
        @i18n = nil
      elsif i18n.is_a? I18n
        @i18n = i18n
      else
        @i18n = I18n.new(i18n, dir)
      end
    end

    # Set I18n object to current thread.
    def thread_set(i18n = nil, &block)
      if block_given?
        Thread.current[:r18n_setter] = block
        Thread.current[:r18n_i18n] = nil
      else
        Thread.current[:r18n_i18n] = i18n
      end
    end

    # Get I18n object for current thread.
    def get
      (thread[:r18n_i18n] ||= ((block = thread[:r18n_setter]) && block.call)) ||
      (@i18n ||= (@setter && @setter.call))
    end

    # Delete I18n object from current thread and global variable.
    def reset
      thread[:r18n_i18n] = thread[:r18n_setter] = @i18n = @setter = nil
      self.cache = {}
    end

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

    # Default loader class, which will be used if you didn’t send loader to
    # +I18n.new+ (object with +available+ and +load+ methods).
    attr_accessor :default_loader

    # Loaders with extension translations. If application translations with
    # same locale isn’t exists, extension file willn’t be used.
    attr_accessor :extension_places

    # Hash of hash-like (see Moneta) object to store loaded translations.
    attr_accessor :cache
  end

  self.default_loader = R18n::Loader::YAML
  self.extension_places = [
      Loader::YAML.new(Pathname(__FILE__).dirname.expand_path + '../base')]
  self.cache = {}
end
