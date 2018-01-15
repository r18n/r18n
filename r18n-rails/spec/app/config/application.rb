# frozen_string_literal: true

require File.expand_path('../boot', __FILE__)

require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'rails/test_unit/railtie'

if defined?(Bundler)
  Bundler.require(*Rails.groups(assets: %w[development test]))
end

module App
  class Application < Rails::Application
    config.time_zone = 'UTC'
    config.i18n.default_locale = :ru
    config.encoding = 'utf-8'

    def config.database_configuration
      sqlite = { 'adapter' => 'sqlite3', 'database' => ':memory:' }
      sqlite['adapter'] = 'jdbcsqlite3' if RUBY_PLATFORM == 'java'
      { 'development' => sqlite, 'test' => sqlite, 'production' => sqlite }
    end
  end
end
