# encoding: utf-8
require File.join(File.dirname(__FILE__), '../lib/sinatra/r18n')
require File.join(File.dirname(__FILE__), 'app/app')

require 'spec/interop/test'
require 'sinatra/test'
Test::Unit::TestCase.send :include, Sinatra::Test

set :environment, :test
