# frozen_string_literal: true

# Filters for translations content.
#
# Copyright (C) 2012 Andrey “A.I.” Sitnik <andrey@sitnik.ru>
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

module R18n
  # Superclass for +GlobalFilterList+ and +CustomFilterList+ with filters
  # processing.
  class FilterList
    # Process +value+ by filters in +enabled+.
    def process(filters_type, type, value, locale, path, params)
      config = { locale: locale, path: path }

      enabled(filters_type, type).each do |filter|
        value = filter.call(value, config, *params)
      end

      if value.is_a? String
        value = TranslatedString.new(value, locale, path)
        process_string(filters_type, value, config, params)
      else
        value
      end
    end

    # Shortcut to process `R18n::Typed`.
    def process_typed(filters_type, typed_value, params)
      process(filters_type,
              typed_value.type,
              typed_value.value,
              typed_value.locale,
              typed_value.path,
              params)
    end

    # Process +value+ by global filters in +enabled+.
    def process_string(filters_type, value, config, params)
      config = { locale: value.locale, path: config } if config.is_a? String

      enabled(filters_type, String).each do |f|
        value = f.call(value, config, *params)
      end

      if value.class == String
        TranslatedString.new(value, config[:locale], config[:path])
      else
        value
      end
    end

    # Array of enabled filters with +filters_type+ for +type+.
    def enabled(filters_type, type)
      if filters_type == :passive
        passive(type)
      elsif filters_type == :active
        active(type)
      else
        all(type)
      end
    end

    # List of enable passive filters.
    def passive(_type)
      []
    end

    # List of enable active filters.
    def active(_type)
      []
    end

    # List of enable filters.
    def all(_type)
      []
    end
  end

  # Filter list for I18n object with only global filters.
  class GlobalFilterList < FilterList
    include Singleton

    def passive(type)
      Filters.passive_enabled[type]
    end

    def active(type)
      Filters.active_enabled[type]
    end

    def all(type)
      Filters.enabled[type]
    end
  end

  # Filter list for I18n object with custom disabled/enabled filters.
  class CustomFilterList < FilterList
    def initialize(on, off)
      @on  = Array(on).map  { |i| Filters.defined[i] }
      @off = Array(off).map { |i| Filters.defined[i] }
      @changed_types = (@on + @off).map(&:types).flatten.uniq

      @changed_passive = (@on + @off).select(&:passive?)
        .map(&:types).flatten.uniq
      @changed_active  = (@on + @off).reject(&:passive?)
        .map(&:types).flatten.uniq

      @on_by_type = {}
      @on.each do |filter|
        filter.types.each do |type|
          @on_by_type[type] ||= []
          @on_by_type[type] << filter
        end
      end
      @off_by_type = {}
      @off.each do |filter|
        filter.types.each do |type|
          @off_by_type[type] ||= []
          @off_by_type[type] << filter
        end
      end
    end

    def passive(type)
      enabled = Filters.passive_enabled[type]
      return enabled unless @changed_passive.include? type
      enabled = enabled.reject { |i| @off_by_type[type].include? i }
      enabled + @on_by_type[type].select(&:passive)
    end

    def active(type)
      enabled = Filters.active_enabled[type]
      return enabled unless @changed_active.include? type
      enabled = enabled.reject { |i| @off_by_type[type].include? i }
      enabled + @on_by_type[type].reject(&:passive)
    end

    def all(type)
      enabled = Filters.enabled[type]
      return enabled unless @changed_types.include? type
      enabled = enabled.reject { |i| @off_by_type[type].include? i }
      enabled + @on_by_type[type]
    end

    def hash
      [@on, @off].hash
    end
  end
end
