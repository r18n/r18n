# frozen_string_literal: true

# R18n support for Rails.
#
# Copyright (C) 2009 Andrey “A.I.” Sitnik <andrey@sitnik.ru>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

require 'r18n-core'
require 'r18n-rails-api'

require_relative 'r18n-rails/helpers'
require_relative 'r18n-rails/hooks_helper'
require_relative 'r18n-rails/translated'
require_relative 'r18n-rails/filters'

R18n.default_places { [Rails.root.join('app/i18n'), R18n::Loader::Rails.new] }

ActionController::Base.helper(R18n::Rails::Helpers)
ActionController::Base.include R18n::Rails::HooksHelper::ForController

if ActionController::Base.respond_to? :before_action
  ActionController::Base.send(:before_action, :set_r18n)
  ActionController::Base.send(:before_action, :reload_r18n) if Rails.env.development?
else
  ActionController::Base.send(:before_filter, :set_r18n)
  ActionController::Base.send(:before_filter, :reload_r18n) if Rails.env.development?
end

if defined? ActionMailer
  ActionMailer::Base.helper(R18n::Rails::Helpers)
  ActionMailer::Base.include R18n::Rails::HooksHelper::ForMailer

  if ActionMailer::Base.respond_to? :before_action
    ActionMailer::Base.send(:before_action, :set_r18n)
    ActionMailer::Base.send(:before_action, :reload_r18n) if Rails.env.development?
  else
    ActionMailer::Base.send(:before_filter, :set_r18n)
    ActionMailer::Base.send(:before_filter, :reload_r18n) if Rails.env.development?
  end
end

ActiveSupport.on_load(:after_initialize) do
  env = ENV['LANG']
  env = env.split('.').first if env
  R18n::I18n.default = I18n.default_locale.to_s
  locales = [env, I18n.default_locale.to_s]
  options =
    if defined?(Rails::Console) && !defined?(Wirble)
      {
        off_filters: :untranslated,
        on_filters: :untranslated_bash
      }
    else
      {}
    end
  i18n = R18n::I18n.new(locales, R18n.default_places, **options)
  R18n.set(i18n)

  I18n.backend = R18n::Backend.new
end
