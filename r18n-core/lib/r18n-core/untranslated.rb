# frozen_string_literal: true

# Untranslation string for i18n support.
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

module R18n
  # Return if translation isn’t exists. Unlike nil, it didn’t raise error when
  # you try to access for subtranslations.
  #
  # You can set format to print untranslated string by filters. For example:
  # Disable standart output:
  #
  #   R18n::Filters.off(:untranslated)
  #
  # For development environment:
  #
  #   R18n::Filters.add(R18n::Untranslated, :untranslated_html) do
  #     |content, config, translated_path, untranslated_path, path|
  #     "#{translated_path}<span style='color: red'>#{untranslated_path}</span>"
  #   end
  #
  # For production environment:
  #
  #   R18n::Filters.add(R18n::Untranslated, :hide_untranslated) { '' }
  class Untranslated
    # Path, that isn’t in translation.
    attr_reader :untranslated_path

    # Path, that exists in translation.
    attr_reader :translated_path

    # Main locale, where string was try to find
    attr_reader :locale

    def initialize(translated_path, untranslated_path, locale, filters)
      @translated_path   = translated_path
      @untranslated_path = untranslated_path
      @locale            = locale
      @filters           = filters
    end

    # Path to translation.
    def path
      "#{@translated_path}#{@untranslated_path}"
    end

    def translated?
      false
    end

    # Override marshal_dump to avoid Marshalizing filter procs
    def _dump(_limit)
      [@locale.code, @translated_path, @untranslated_path].join(':')
    end

    # Load object from Marshalizing.
    def self._load(str)
      arr = str.split(':', 3)
      new arr[1], arr[2], R18n.locale(arr[0]), GlobalFilterList.instance
    end

    NON_KEYS_METHODS = %i[
      to_ary
      marshal_dump
      marshal_load
    ].freeze

    def method_missing(name, *_params)
      # It is need to fix some hack in specs
      return super if NON_KEYS_METHODS.include?(name)

      self[name]
    end

    def respond_to_missing?(name, *args)
      return super if NON_KEYS_METHODS.include?(name)
      true
    end

    def [](*params)
      Untranslated.new(translated_path, "#{@untranslated_path}.#{params.first}",
                       @locale, @filters)
    end

    def |(other)
      other
    end

    def to_s
      @filters.process(
        :all, Untranslated, path, @locale, path,
        [@translated_path, @untranslated_path, path]
      ).to_s
    end

    alias to_str to_s

    # Is another locale has same code.
    def ==(other)
      return false unless other.is_a? Untranslated
      return false unless locale            == other.locale
      return false unless translated_path   == other.translated_path
      return false unless untranslated_path == other.untranslated_path
      true
    end
  end
end
