# encoding: utf-8
$TESTING=true

require 'rubygems'
require 'merb-core'
require 'merb-slices'

require File.dirname(__FILE__) / '../lib/merb_r18n'
require File.dirname(__FILE__) / 'app/controllers/i18n'

Merb.push_path(:i18n, File.dirname(__FILE__) / 'app/i18n')

Merb::Plugins.config[:merb_slices][:auto_register] = true
Merb::Plugins.config[:merb_slices][:search_path] = File.dirname(__FILE__) / 'app/'
Merb::Router.prepare { add_slice(:slice) }

Merb.start :environment => 'test'

Spec::Runner.configure do |config|
  config.include Merb::Test::RequestHelper
end
