# encoding: utf-8
=begin
Converter between R18n and Rails I18n plural keys.

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
  # Converter between R18n and Rails I18n plural keys.
  class RailsPlural
    # Check, that +key+ is Rails plural key.
    def self.is_rails?(k)
      [:zero, :one, :few, :many, :other].include? k
    end

    # Convert Rails I18n plural key to R18n.
    def self.to_r18n(k)
      { :zero  => 0, :one => 1, :few => 2, :many => 'n', :other => 'n' }[k]
    end

    # Convert R18n plural key to Rails I18n.
    def self.from_r18n(k)
      { 0 => :zero, 1 => :one, 2 => :few, 'n' => :other }[k]
    end
  end
end
