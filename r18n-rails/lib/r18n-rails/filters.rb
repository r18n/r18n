# frozen_string_literal: true

# Load R18n filters from Rails app directory.
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
  module Rails
    # Load and remove filters from ruby files in `app/i18n`.
    class Filters
      class << self
        # Path list of filters, which are loaded from app dir.
        attr_accessor :loaded

        # Path to filters. Should be set to `app/i18n`.
        attr_writer :path

        def path
          return @path if defined?(@path)

          ::Rails.root.join('app/i18n')
        end

        # Load all ruby files from `app/i18n` and remember loaded filters.
        def load!
          @loaded = R18n::Filters.listen do
            Pathname.glob(path.join('**/*.rb').to_s) { |i| load i.to_s; }
          end.map(&:name)
        end

        # Shortcut to call `remove!` and `load!`.
        def reload!
          remove!
          load!
        end

        # Remove filters, loaded by `load!`.
        def remove!
          @loaded.each { |i| R18n::Filters.delete(i) }
          @loaded = []
        end
      end
    end

    Filters.loaded = []
  end
end
