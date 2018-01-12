# frozen_string_literal: true

require 'pp'

ENV['RAILS_ENV'] ||= 'test'
dir = File.dirname(__FILE__)
require File.expand_path(File.join(dir, 'app/config/environment'))
require File.expand_path(File.join(dir, '../lib/r18n-rails'))

require 'rspec/rails'
