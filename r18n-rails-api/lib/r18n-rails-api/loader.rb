# frozen_string_literal: true

# Loader for Rails translations.
#
# Copyright (C) 2009 Andrey “A.I.” Sitnik <andrey@sitnik.ru>
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

require 'i18n'

module R18n
  module Loader
    # Loader for translations in Rails I18n format:
    #
    #   R18n::I18n.new('en', R18n::Loader::Rails.new)
    #
    # It use Rails I18n backend to load translations. By default, simple
    # backend will be used, by you can change it, if use extended backend
    # (for example, with ActiveRecord storage):
    #
    #   R18n::I18n.new('en',
    #                  R18n::Loader::Rails.new(I18n::Backend::ActiveRecord.new))
    class Rails
      include ::R18n::YamlMethods

      # Create new loader for some +backend+ from Rails I18n. Backend must have
      # +reload!+, +init_translations+ and +translations+ methods.
      def initialize(backend = ::I18n::Backend::Simple.new)
        @backend = backend
        detect_yaml_private_type
      end

      # Array of locales, which has translations in +I18n.load_path+.
      def available
        reload!
        @translations.keys.map { |code| R18n.locale(code) }
      end

      # Return Hash with translations for +locale+.
      def load(locale)
        initialize_types
        reload!
        @translations[locale.code]
      end

      # Reload backend if <tt>I18n.load_path</tt> is changed.
      def reload!
        return if defined?(@last_path) && @last_path == ::I18n.load_path
        @last_path = ::I18n.load_path.clone
        @backend.reload!
        @backend.send(:init_translations)
        @translations = transform @backend.send(:translations)
      end

      # Return hash for object and <tt>I18n.load_path</tt>.
      def hash
        ::I18n.load_path.hash
      end

      # Is another +loader+ is also load Rails translations.
      def ==(other)
        self.class == other.class
      end

      protected

      # Change pluralization and keys to R18n format.
      def transform(value)
        if value.is_a? Hash
          if value.empty?
            value
          elsif value.keys.inject(true) { |a, i| a && RailsPlural.is_rails?(i) }
            Typed.new(
              'pl',
              R18n::Utils.hash_map(value) do |k, v|
                [RailsPlural.to_r18n(k), transform(v)]
              end
            )
          else
            Utils.hash_map(value) { |k, v| [k.to_s, transform(v)] }
          end
        elsif defined?(@private_type_class) && value.is_a?(@private_type_class)
          Typed.new(value.type_id, value.value)
        else
          value
        end
      end
    end
  end
end
