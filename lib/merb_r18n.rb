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
  unless Merb.load_paths.include? :i18n
    Merb.push_path(:i18n, Merb.root / 'app' / 'i18n')
  end

  module Merb
    class Controller
      # Return tool for i18n support. It will be R18n::I18n object, see it
      # documentation for more information.
      def i18n
        unless @i18n
          R18n::I18n.default = Merb::Plugins.config[:merb_r18n][:default_locale]
          
          locales = R18n::I18n.parse_http(request.env['HTTP_ACCEPT_LANGUAGE'])
          locales.insert(0, params[:locale]) if params[:locale]
          
          @i18n = R18n::I18n.new(locales, self.i18n_dirs)
        end
        @i18n
      end
      
      # Dirs to load translations
      def i18n_dirs
        Merb.dir_for(:i18n)
      end
    end
  end
  
  Merb::BootLoader.after_app_loads do
    if defined? Merb::Slices
      Merb::Slices.each_slice do |slice|
        unless slice.slice_paths.include? :i18n
          slice.push_path :i18n, slice.root_path('app' / 'i18n')
        end
      end
      
      module Merb::Slices::ControllerMixin::MixinMethods::InstanceMethods
        def i18n_dirs
          [self.slice.dir_for(:i18n), Merb.dir_for(:i18n)]
        end
      end
    end
  end
end
