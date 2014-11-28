# encoding: utf-8
=begin
Base methods to load translations for YAML.

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
  # Base methods to load translations for YAML.
  # It is used by YAML and Rails loaders.
  module YamlMethods
    # Detect class for private type depend on YAML parser.
    def detect_yaml_private_type
      @private_type_class = if '1.8.' == RUBY_VERSION[0..3]
        ::YAML::PrivateType
      elsif 'syck' == ::YAML::ENGINE.yamler
        ::Syck::PrivateType
      end
    end

    # Register global types in Psych
    def initialize_types
      if '1.8.' != RUBY_VERSION[0..3] and 'psych' == ::YAML::ENGINE.yamler
        Filters.by_type.keys.each do |type|
          next unless type.is_a? String
          # Yeah, I add R18n’s types to global, send me patch if you really
          # use YAML types too ;).
          Psych.add_domain_type('yaml.org,2002', type) do |full_type, value|
            Typed.new(type, value)
          end
        end
      end
    end
  end
end
