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
require 'r18n'

# make sure we're running inside Merb
if defined?(Merb::Plugins)
  Merb.push_path(:translations, Merb.root / "app" / "translations")
  
  Merb::Plugins.config[:merb_r18n] = {
    :default_locale   => 'en',
    :translations_dir => Merb.dir_for(:translations)
  }
  
  module Merb
    class Controller
      before do
        config = Merb::Plugins.config[:merb_r18n]
        R18n::I18n.default = config[:default_locale]
        
        R18n.from_http(config[:translations_dir], 
          request.env['HTTP_ACCEPT_LANGUAGE'], params[:locale])
      end
      
      # Return tool fot i18n support. It will be R18n::I18n object, see it
      # documentation for more information.
      def i18n
        R18n.get
      end
    end
  end
end
