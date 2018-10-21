# frozen_string_literal: true

# Locale withou information file to i18n support.
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
  # Locale without information file. Contain only it code, empty title and data
  # from default locale.
  class UnsupportedLocale
    # Locale, to get data and pluralization for unsupported locale.
    attr_accessor :base

    # Create object for unsupported locale with +code+ and load other locale
    # data from +base+ locale.
    def initialize(code, _base = nil)
      @code = code
      @base = Locale.load(I18n.default) if @code != I18n.default
    end

    # Is locale has information file. In this class always return false.
    def supported?
      false
    end

    # Human readable locale code and title.
    def inspect
      "Unsupported locale #{@code}"
    end

    # Locale RFC 3066 code.
    attr_reader :code

    # Locale code as title.
    def title
      @code
    end

    # Is another locale has same code.
    def ==(other)
      @code.casecmp(other.code).zero?
    end

    #  Proxy to default locale object.
    def method_missing(name, *params)
      return super unless @base.respond_to? name
      @base.public_send(name, *params)
    end

    def respond_to_missing?(name, *args)
      @base.send __method__, name, *args
    end
  end
end
