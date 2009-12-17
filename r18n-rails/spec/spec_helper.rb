require 'pp'

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path(File.join(File.dirname(__FILE__), 'app/config/environment'))
require 'spec'
require 'spec/rails'
