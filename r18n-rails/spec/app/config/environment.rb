require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.time_zone = 'UTC'
  
  config.gem 'r18n-rails', :lib => Rails.root + '../../lib/r18n-rails'
  
  config.i18n.default_locale = :ru
end
