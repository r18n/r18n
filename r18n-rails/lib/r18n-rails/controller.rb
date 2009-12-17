=begin
Methods and filters to controllers.

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

require 'r18n-rails-api'

module R18n
  module Rails
    module Controller
      private
      
      # Return current R18n instance.
      def r18n
        R18n.get
      end
      
      # Auto detect user locales and change backend.
      def set_r18n
        R18n.set do
          locales = R18n::I18n.parse_http(request.env['HTTP_ACCEPT_LANGUAGE'])
          
          if params[:locale]
            locales.insert(0, params[:locale])
          elsif session[:locale]
            locales.insert(0, session[:locale])
          end
          
          places = [::Rails.root.join('app/i18n'), R18n::Loader::Rails.new]
          
          R18n::I18n.new(locales, places)
        end
      
        ::I18n.backend = R18n::Backend.new
      end
    end
  end
end
