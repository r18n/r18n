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

$KCODE = 'u'

require 'pathname'
dir = Pathname(__FILE__).dirname.expand_path + 'r18n'

require dir + 'locale'
require dir + 'translated_string'
require dir + 'translation'
require dir + 'i18n'

module R18n
  class << self
    # Set <tt>i18n</tt> object to current thread
    def set(i18n)
      Thread.current['i18n'] = i18n
    end
    
    # Get I18n object for current thread
    def get
      Thread.current['i18n']
    end
    
    # Get user locale from system environment and load I18n object with locale
    # information and translations from +translations_dir+. If user set locale
    # +manual+ put it as last argument.
    def from_env(translations_dir, manual = nil)
      #TODO Support for Windows and JRuby
      locales = ENV['LANG'].split('.').first.to_a
      locales.insert(0, manual) if not manual.nil?
      self.set I18n.new(locales, translations_dir)
    end
    
    # Parse +http_accept_language+ and load I18n object with locales information
    # and translations from +translations_dir+. If user set locale +manual+ put
    # it as last argument.
    def from_http(translations_dir, http_accept_language, manual = nil)
      locales = I18n.parse_http_accept_language(http_accept_language)
      locales.insert(0, manual) if not manual.nil?
      self.set I18n.new(locales, translations_dir)
    end
  end
end
