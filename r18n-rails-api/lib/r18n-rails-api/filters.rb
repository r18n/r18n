=begin
Filters for Rails I18n compatibility for R18n.

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

# Filter to use Rails named variables:
# 
#   name: "My name is %{name}"
# 
#   i18n.name(name: 'Ivan') #=> "My name is Ivan"
R18n::Filters.add(String, :named_variables) do |content, config, params|
  if params.is_a? Hash
    content = content.clone
    params.each_pair do |name, value|
      v = config[:locale].localize(value)
      content.gsub! "%{#{name}}", v
      content.gsub! "{{#{name}}}", v
    end
  end
  content
end

# Pluralization by named variable <tt>%{count}</tt>.
R18n::Filters.add('pl', :named_pluralization) do |content, config, param|
  if param.is_a? Hash and param.has_key? :count
    type = config[:locale].pluralize(param[:count])
    type = 'n' if not content.has_key? type
    content[type]
  else
    content
  end
end
