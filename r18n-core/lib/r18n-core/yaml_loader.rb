# encoding: utf-8
=begin
Loader for YAML translations.

Copyright (C) 2009 Andrey “A.I.” Sitnik <andrey@sitnik.ru>

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

require 'yaml'

module R18n
  module Loader
    # Loader for translations in YAML format. Them should have name like
    # +en.yml+ (English) or en-US.yml (USA English dialect) with
    # language/country code (RFC 3066).
    # 
    #   R18n::I18n.new('en', R18n::Loader::YAML.new('dir/with/translations'))
    # 
    # YAML loader is default loader, so you can just set constructor parameter
    # to <tt>R18n::I18n.new</tt>:
    # 
    #   R18n::I18n.new('en', 'dir/with/translations')
    class YAML
      # Array of locales, which has translations in +dir+.
      attr_reader :available
      
      # Dir with translations.
      attr_reader :dir
      
      # Create new loader for +dir+ with YAML translations.
      def initialize(dir)
        @dir = File.expand_path(dir)
        @available = Dir.glob(File.join(@dir, '*.yml')).map do |i|
          R18n::Locale.load(File.basename(i, '.yml'))
        end
      end
      
      # Return Hash with translations for +locale.
      def load(locale)
        ::YAML::load_file(File.join(@dir, "#{locale.code.downcase}.yml"))
      end
      
      # Is another +loader+ load YAML translations from same +dir+.
      def ==(loader)
        self.class == loader.class and self.dir == loader.dir
      end
    end
  end
end
