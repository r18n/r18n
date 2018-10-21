# frozen_string_literal: true

## https://github.com/stevekinney/pizza/issues/103#issuecomment-136052789
## https://github.com/docker-library/ruby/issues/45
Encoding.default_external = 'UTF-8'

require 'pp'

ENV['RAILS_ENV'] ||= 'test'

require_relative 'app/config/environment'
require_relative '../lib/r18n-rails'

require 'rspec/rails'
