# encoding: utf-8
=begin
Sinatra extension to i18n support.

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

require 'sinatra/base'
require 'r18n-core'

module Sinatra
  module R18n
    def self.registered(app)
      app.helpers ::R18n::Helpers
      app.set :default_locale, Proc.new { ::R18n::I18n.default }
      app.set :translations,   Proc.new { ::R18n.default_places }

      ::R18n.default_places { File.join(app.root, 'i18n/') }

      app.before do
        ::R18n.clear_cache! if self.class.development?

        ::R18n.thread_set do
          if settings.default_locale
            ::R18n::I18n.default = settings.default_locale
          end

          locales = ::R18n::I18n.parse_http(request.env['HTTP_ACCEPT_LANGUAGE'])
          if params[:locale]
            locales.insert(0, params[:locale])
          elsif session[:locale]
            locales.insert(0, session[:locale])
          end

          ::R18n::I18n.new(locales, ::R18n.default_places,
            :off_filters => :untranslated, :on_filters => :untranslated_html)
        end
      end
    end
  end

  register R18n
end
