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
      include ::R18n::YamlMethods

      # Dir with translations.
      attr_reader :dir

      # Create new loader for +dir+ with YAML translations.
      def initialize(dir)
        @dir = File.expand_path(dir)
        detect_yaml_private_type
      end

      # Array of locales, which has translations in +dir+.
      def available
        Dir.glob(File.join(@dir, '**/*.yml')).
          map { |i| File.basename(i, '.yml') }.uniq.
          map { |i| R18n.locale(i) }.uniq
      end

      # Return Hash with translations for +locale+.
      def load(locale)
        initialize_types

        translations = {}
        Dir.glob(File.join(@dir, "**/#{locale.code.downcase}*.yml")).each do |i|
          Utils.deep_merge!(translations, ::YAML::load_file(i) || {})
        end
        transform(translations)
      end

      # YAML loader with same +dir+ will be have same +hash+.
      def hash
        self.class.hash + @dir.hash
      end

      # Is another +loader+ load YAML translations from same +dir+.
      def ==(loader)
        self.class == loader.class and self.dir == loader.dir
      end

      # Wrap YAML private types to Typed.
      def transform(a_hash)
        R18n::Utils.hash_map(a_hash) do |key, value|
          if value.is_a? Hash
            value = transform(value)
          elsif @private_type_class and value.is_a? @private_type_class
            v = value.value
            if v.respond_to?(:force_encoding) and v.encoding != __ENCODING__
              v = v.force_encoding(__ENCODING__)
            end
            value = Typed.new(value.type_id, v)
          end
          [key, value]
        end
      end
    end
  end
end
