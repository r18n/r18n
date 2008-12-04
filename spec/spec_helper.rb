$TESTING=true

require 'rubygems'
require 'merb-core'

require File.dirname(__FILE__) / '../lib/merb_r18n'
require File.dirname(__FILE__) / 'app/controllers/i18n'

Merb.push_path(:i18n, File.dirname(__FILE__) / 'app/i18n')

Merb.start :environment => 'test'

Spec::Runner.configure do |config|
  config.include Merb::Test::RequestHelper
end
