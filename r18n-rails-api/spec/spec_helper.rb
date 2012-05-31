# encoding: utf-8
require 'pp'
require 'i18n'
require 'active_support'

require File.join(File.dirname(__FILE__), '../lib/r18n-rails-api')

EN = R18n.locale(:en)
RU = R18n.locale(:ru)

GENERAL = Dir.glob(File.join(File.dirname(__FILE__), 'data/general/*'))
SIMPLE  = Dir.glob(File.join(File.dirname(__FILE__), 'data/simple/*'))
OTHER   = Dir.glob(File.join(File.dirname(__FILE__), 'data/other/*'))
