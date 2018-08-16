# frozen_string_literal: true

# Methods and filters to controllers.
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

require 'r18n-rails-api'

module R18n
  module Rails
    module Controller
      include Helpers

      private

      # Auto detect user locales and change backend.
      def set_r18n
        R18n.set do
          R18n::I18n.default = ::I18n.default_locale.to_s
          locales = R18n::I18n.parse_http(request.env['HTTP_ACCEPT_LANGUAGE'])

          if params[:locale]
            locales.unshift(params[:locale])
          elsif session[:locale]
            locales.unshift(session[:locale])
          end

          i18n = R18n::I18n.new(
            locales, R18n.default_places,
            off_filters: :untranslated, on_filters: :untranslated_html
          )
          ::I18n.locale = i18n.locale.code.to_sym
          i18n
        end
      end

      # Clean cache and reload filters from ruby files in `app/i18n`.
      # Used only for development.
      def reload_r18n
        R18n.clear_cache!
        R18n::Rails::Filters.reload!
        R18n.get.try(:reload!)
      end
    end
  end
end
