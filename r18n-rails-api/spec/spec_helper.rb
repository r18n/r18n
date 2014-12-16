require 'pp'
require 'i18n'
require 'active_support'

I18n.enforce_available_locales = true

require File.join(File.dirname(__FILE__), '../lib/r18n-rails-api')

EN = R18n.locale(:en)
RU = R18n.locale(:ru)
DE = R18n.locale(:de)

GENERAL = Dir.glob(File.join(File.dirname(__FILE__), 'data/general/*'))
SIMPLE  = Dir.glob(File.join(File.dirname(__FILE__), 'data/simple/*'))
OTHER   = Dir.glob(File.join(File.dirname(__FILE__), 'data/other/*'))
PL      = Dir.glob(File.join(File.dirname(__FILE__), 'data/pl/*'))
