# frozen_string_literal: true

require 'pp'

ENV['RAILS_ENV'] ||= 'test'

require_relative 'app/config/environment'
require_relative '../lib/r18n-rails'

require 'rspec/rails'
