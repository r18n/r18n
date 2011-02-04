=begin
ActiveRecord fix mixin to R18n::Translated.

Copyright (C) 2011 Andrey “A.I.” Sitnik <andrey@sitnik.ru>

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

module R18n
  module Translated
    module Base
      def unlocalized_methods
        if ancestors.include? ActiveRecord::Base
          column_names + column_names.map { |i| i + '=' } + instance_methods
        else
          instance_methods
        end
      end
    end
  end
end
