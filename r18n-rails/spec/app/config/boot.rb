# frozen_string_literal: true

# Set up gems listed in the Gemfile.
ENV['BUNDLE_GEMFILE'] ||= File.join(__dir__, '..', 'Gemfile')

require 'bundler/setup' if File.exist?(ENV['BUNDLE_GEMFILE'])
