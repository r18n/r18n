# encoding: utf-8
require 'pp'

require File.join(File.dirname(__FILE__), 'app/app')

require 'spec/interop/test'
gem 'rack-test'
require 'rack/test'
Test::Unit::TestCase.send(:include, Rack::Test::Methods)
Test::Unit::TestCase.send(:define_method, :app) { Sinatra::Application }

set :environment, :test
