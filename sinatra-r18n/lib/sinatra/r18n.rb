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

module Sinatra #::nodoc::
  module R18n #::nodoc::
    def self.registered(app) #::nodoc::
      app.helpers ::R18n::Helpers
      app.set :default_locale, 'en'
      app.set :translations, Proc.new { File.join(app.root, 'i18n/') }
      
      app.before do
        ::R18n.set do
          ::R18n::I18n.default = options.default_locale
          
          locales = ::R18n::I18n.parse_http(request.env['HTTP_ACCEPT_LANGUAGE'])
          if params[:locale]
            locales.insert(0, params[:locale])
          elsif session[:locale]
            locales.insert(0, session[:locale])
          end
          
          ::R18n::I18n.new(locales, options.translations)
        end
      end
      
      ::R18n::Filters.off(:untranslated)
      ::R18n::Filters.add(::R18n::Untranslated, :untranslated_html) do
        |content, config, translated_path, untranslated_path, path|
        "#{translated_path}<span style='color: red'>#{untranslated_path}</span>"
      end
      app.configure :production do
        ::R18n::Filters.add(::R18n::Untranslated, :hide_untranslated) { '' }
      end
    end
  end
  
  register R18n
end
