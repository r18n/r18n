require File.expand_path('../boot', __FILE__)

require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "active_resource/railtie"
require "rails/test_unit/railtie"

Bundler.require(:default, Rails.env) if defined?(Bundler)

module App
  class Application < Rails::Application
    config.time_zone = 'UTC'
    config.i18n.default_locale = :ru
    config.action_view.javascript_expansions[:defaults] = []
    config.encoding = "utf-8"
    config.filter_parameters += [:password]
  end
end
