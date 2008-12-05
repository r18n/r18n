=begin
Merb plugin to i18n support.

Copyright (C) 2008 Andrey “A.I.” Sitnik <andrey@sitnik.ru>

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
gem 'r18n-core', '~>0.1'
require 'r18n-core'

# make sure we're running inside Merb
if defined? Merb::Plugins
  Merb::Plugins.config[:merb_r18n] = {
    :default_locale   => 'en'
  }
  Merb.push_path(:i18n, Merb.root / 'app' / 'i18n')

  module Merb
    class Controller
      # Return tool for i18n support. It will be R18n::I18n object, see it
      # documentation for more information.
      def i18n
        unless @i18n
          R18n::I18n.default = Merb::Plugins.config[:merb_r18n][:default_locale]
          
          locales = R18n::I18n.parse_http(request.env['HTTP_ACCEPT_LANGUAGE'])
          locales.insert(0, params[:locale]) if params[:locale]
          
          @i18n = R18n::I18n.new(locales, Merb.dir_for(:i18n))
        end
        @i18n
      end
    end
  end
end
