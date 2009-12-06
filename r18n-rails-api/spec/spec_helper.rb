require 'rubygems'
require 'pp'
gem 'i18n'

require File.join(File.dirname(__FILE__), '../lib/r18n-rails-api')

EN = R18n::Locale.load(:en)
RU = R18n::Locale.load(:ru)

I18n.load_path << Dir.glob(File.join(File.dirname(__FILE__), 'translations/*'))
OTHER = Dir.glob(File.join(File.dirname(__FILE__), 'other_translations/*'))
