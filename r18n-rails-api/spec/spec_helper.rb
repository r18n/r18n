# encoding: utf-8
require 'pp'
require 'i18n'

require File.join(File.dirname(__FILE__), '../lib/r18n-rails-api')

EN = R18n::Locale.load(:en)
RU = R18n::Locale.load(:ru)

GENERAL = Dir.glob(File.join(File.dirname(__FILE__), 'data/general/*'))
SIMPLE  = Dir.glob(File.join(File.dirname(__FILE__), 'data/simple/*'))
OTHER   = Dir.glob(File.join(File.dirname(__FILE__), 'data/other/*'))
