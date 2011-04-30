# encoding: utf-8

ENV['RACK_ENV'] = 'test'

require 'rubygems'
require 'bundler/setup'
require 'pp'
require 'sinatra'

require File.join(File.dirname(__FILE__), 'app/app')

# require 'spec/interop/test'
require 'rack/test'

module RSpecMixinExample
  include Rack::Test::Methods
  def app(); Sinatra::Application; end
end

RSpec.configure { |c| c.include RSpecMixinExample }

set :environment, :test
set :root, File.join(File.dirname(__FILE__), 'app')
