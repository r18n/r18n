# frozen_string_literal: true

source 'https://rubygems.org'

gem 'rake'
gem 'rspec'

gem 'i18n', require: false
gem 'kramdown', require: false
gem 'rack', require: false
gem 'rails', require: false
gem 'RedCloth', require: false
gem 'rspec-rails', require: false
gem 'sinatra', require: false

gem 'sqlite3'

gem 'r18n-core',      path: 'r18n-core/'
gem 'r18n-rails',     path: 'r18n-rails/',     require: false
gem 'r18n-rails-api', path: 'r18n-rails-api/', require: false

group :development do
  gem 'pry-byebug', require: false
  gem 'rbench', require: false
  gem 'redcarpet', require: false
end

group :development, :lint do
  gem 'rubocop', '~> 1.6', require: false
  gem 'rubocop-performance', '~> 1.9', require: false
  gem 'rubocop-rails', '~> 2.9', require: false
  gem 'rubocop-rake', '~> 0.5.1', require: false
  # gem 'rubocop-rspec', '~> 2.2', require: false
end
