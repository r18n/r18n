# frozen_string_literal: true

# Filters for Rails I18n compatibility for R18n.
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

# Filter to use Rails named variables:
#
#   name: "My name is %{name}"
#
#   i18n.name(name: 'Ivan') #=> "My name is Ivan"
R18n::Filters.add(String, :named_variables) do |content, config, params|
  if params.is_a? Hash
    content = content.clone
    params.each_pair do |name, value|
      value = config[:locale].localize(value)
      if defined? ActiveSupport::SafeBuffer
        value = ActiveSupport::SafeBuffer.new + value
      end
      content.gsub! "%{#{name}}",  value
      content.gsub! "{{#{name}}}", value
    end
  end
  content
end

module R18n
  # Class to mark unpluralized translation and convert Rails plural keys
  class RailsUnpluralizedTranslation < UnpluralizedTranslation
    def [](name, *params)
      result = super
      if result.is_a? Untranslated
        fixed = super(RailsPlural.to_r18n(name), *params)
        result = fixed unless fixed.is_a? Untranslated
      end
      result
    end
  end
end

# Pluralization by named variable `%{count}`.
R18n::Filters.add('pl', :named_pluralization) do |content, config, param|
  if param.is_a?(Hash) && param.key?(:count)
    hash = content.to_hash
    type = config[:locale].pluralize(param[:count])
    type = 'n' unless hash.key?(type)
    hash[type]
  elsif content.is_a? R18n::UnpluralizedTranslation
    R18n::RailsUnpluralizedTranslation.new(
      config[:locale], config[:path],
      locale: config[:locale], translations: content.to_hash
    )
  else
    content
  end
end
