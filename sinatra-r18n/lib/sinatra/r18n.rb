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

require 'rubygems'
gem 'sinatra'
require 'sinatra/base'

gem 'r18n-core', '~>0.2.3'
require 'r18n-core'

R18n.untranslated = '%2<span style="color: red">%3</span>'

module Sinatra #::nodoc::
  module R18n #::nodoc::
    module Helpers
      # Return tool for i18n support. It will be R18n::I18n object, see it
      # documentation for more information.
      def i18n
        unless @i18n
          ::R18n::I18n.default = options.default_locale
          
          locales = ::R18n::I18n.parse_http(request.env['HTTP_ACCEPT_LANGUAGE'])
          if params[:locale]
            locales.insert(0, params[:locale])
          elsif session[:locale]
            locales.insert(0, session[:locale])
          end
          
          @i18n = ::R18n::I18n.new(locales, options.translations)
        else
          @i18n
        end
      end
    end
  
    def self.registered(app) #::nodoc::
      app.helpers Helpers
      app.set :default_locale, 'en'
      app.set :translations, Proc.new { File.join(app.root, 'i18n/') }
    end
  end
  
  register R18n
end
