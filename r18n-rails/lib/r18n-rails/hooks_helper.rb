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
    module HooksHelper
      module Common
        include Helpers

        private

        # Clean cache and reload filters from ruby files in `app/i18n`.
        # Used only for development.
        def reload_r18n
          R18n.clear_cache!
          R18n::Rails::Filters.reload!
          R18n.get.try(:reload!)
        end
      end

      module ForController
        include Common

        private

        # Auto detect user locales and set.
        def set_r18n
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
          R18n.set i18n
          ## To not prevent action
          ## Also don't use `puts`
          nil
        end
      end

      module ForMailer
        include Common

        private

        # Set locale from `::I18n`
        def set_r18n
          R18n::I18n.default = ::I18n.default_locale.to_s
          i18n = R18n::I18n.new(
            ::I18n.locale, R18n.default_places,
            off_filters: :untranslated, on_filters: :untranslated_html
          )
          R18n.set i18n
        end
      end
    end
  end
end
