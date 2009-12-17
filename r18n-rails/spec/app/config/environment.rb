RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.time_zone = 'UTC'
  config.frameworks -= [:active_record]
  
  config.gem 'r18n-rails', :lib => Rails.root + '../../lib/r18n-rails'
end
