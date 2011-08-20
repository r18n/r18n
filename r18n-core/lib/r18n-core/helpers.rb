# encoding: utf-8
=begin
Mixin with common methods.

Copyright (C) 2010 Andrey “A.I.” Sitnik <andrey@sitnik.ru>

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
  # Useful aliases. Set I18n object before use them:
  #
  #   R18n.set('en')
  #
  #   t.ok               #=> "OK"
  #   l Time.now, :human #=> "now"
  #   r18n.locale.code   #=> "en"
  module Helpers
    # Get current I18n object.
    def r18n
      R18n.get
    end
    alias i18n r18n

    # Translate message. Alias for <tt>r18n.t</tt>.
    def t(*params)
      R18n.get.t(*params)
    end

    # Localize object. Alias for <tt>r18n.l</tt>.
    def l(*params)
      R18n.get.l(*params)
    end
  end
end
