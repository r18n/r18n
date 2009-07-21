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
require dir + 'locale'
require dir + 'unsupported_locale'
require dir + 'translated_string'
require dir + 'untranslated'
require dir + 'translation'
require dir + 'i18n'

module R18n
  class << self
    # Set I18n object to current thread.
    def set(i18n)
      Thread.current['i18n'] = i18n
    end
    
    # Get I18n object for current thread.
    def get
      Thread.current['i18n']
    end
    
    # String, which will be print by untranslated items. You can use special
    # values:
    # * <tt>%1</tt> – path to untranslated string.
    # * <tt>%2</tt> – part in path, that exists in translation.
    # * <tt>%3</tt> – part in path, that isn’t exists in translation.
    #
    # For example, if you have in translation only:
    #   user:
    #     login: Login
    #
    # And write code:
    #
    #   R18n.untranslated = '%2[%3]'
    #   
    #   i18n.user.password #=> "user.[password]"
    attr_accessor :untranslated
  end
  
  self.untranslated = '%1'
  
  module Utils
    # Recursively hash merge.
    def self.deep_merge!(a, b)
      b.each_pair do |name, value|
        if a[name].is_a? Hash
          self.deep_merge!(a[name], value)
        else
          a[name] = value
        end
      end
      a
    end
  end
end
