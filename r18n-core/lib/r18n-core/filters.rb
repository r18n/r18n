# encoding: utf-8
=begin
Filters for translations content.

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

module R18n
  # Filter is a way, to process translations: escape HTML entries, convert from
  # Markdown syntax, etc.
  # 
  # In translation file filtered content must be marked by YAML type:
  # 
  #   filtered: !!no_space
  #     This content will be processed by filter
  # 
  # Filter function will be receive filtered content as first argument and
  # filter parameters as next arguments:
  # 
  #   R18n::Filters.add(:no_space) do |content, replace|
  #     content.gsub(' ', replace)
  #   end
  #   
  #   i18n.filtered('_') #=> "This_content_will_be_processed_by_filter"
  module Filters
    class << self
      # Hash of filter names to Proc.
      def defined
        @defined ||= {}
      end
      
      # Add new filter with +name+. Filter content will be sent as first
      # argument to +block+ and filters parameters will be in next arguments.
      # 
      # If filter with this +name+ already exists, it will be replaced.
      def add(name, &block)
        defined[name.to_s] = block
      end
      
      # Delete filter with +name+.
      def delete(name)
        defined.delete(name.to_s)
      end
      
      # Return filter with +name+.
      def [](name)
        defined[name.to_s]
      end
    end
  end
end
