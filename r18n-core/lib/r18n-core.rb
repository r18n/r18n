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
require dir + 'version'
require dir + 'utils'
require dir + 'locale'
require dir + 'unsupported_locale'
require dir + 'translated_string'
require dir + 'untranslated'
require dir + 'filters'
require dir + 'translation'
require dir + 'yaml_loader'
require dir + 'i18n'

module R18n
  class << self
    # Set I18n object to current thread.
    def set(i18n = nil, &block)
      if block_given?
        @setter = block
        @i18n = nil
      else
        @i18n = i18n
      end
    end
    
    # Get I18n object for current thread.
    def get
      @i18n ||= (@setter.call if @setter)
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
