=begin
R18n support for Rails.

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

require 'pathname'
require 'r18n-core'
require 'r18n-rails-api'

dir = Pathname(__FILE__).dirname.expand_path + 'r18n-rails'
require dir + 'helpers'
require dir + 'controller'
require dir + 'translated'

R18n.default_places { [Rails.root.join('app/i18n'), R18n::Loader::Rails.new] }

ActionController::Base.helper(R18n::Rails::Helpers)
ActionController::Base.send(:include, R18n::Rails::Controller)
ActionController::Base.send(:before_filter, :set_r18n)

ActionMailer::Base.helper(R18n::Rails::Helpers) if defined? ActionMailer
