# encoding: utf-8
=begin
Common methods for i18n support.

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

# Common methods for another R18n code.
module R18n
  module Utils
    # Convert Time to Date. Backport from Ruby 1.9.
    def self.to_date(time)
      jd = Date.send(:civil_to_jd, time.year, time.mon, time.mday, Date::ITALY)
      Date.new!(Date.send(:jd_to_ajd, jd, 0, 0), 0, Date::ITALY)
    end
    
    HTML_ENTRIES = { '&'=>'&amp;', '<'=>'&lt;', '>'=>'&gt;' }
    
    # Escape HTML entries (<, >, &). Copy from HAML helper.
    def self.escape_html(content)
      content.to_s.gsub(/[><&]/) { |s| HTML_ENTRIES[s] }
    end

    def self.hash_map(hash)
      result = {}
      hash.each_pair do |key, val|
        new_key, new_value = yield key, val
        result[new_key] = new_value
      end
     result
    end
  end
end
