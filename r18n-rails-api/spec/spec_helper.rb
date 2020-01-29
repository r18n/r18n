# frozen_string_literal: true

require 'pp'
require 'i18n'
require 'active_support'

I18n.enforce_available_locales = true

require_relative '../lib/r18n-rails-api'

EN   = R18n.locale(:en)
RU   = R18n.locale(:ru)
DECH = R18n.locale(:'de-CH')

GENERAL = Dir.glob(File.join(__dir__, 'data', 'general', '*'))
SIMPLE  = Dir.glob(File.join(__dir__, 'data', 'simple', '*'))
OTHER   = Dir.glob(File.join(__dir__, 'data', 'other', '*'))
PL      = Dir.glob(File.join(__dir__, 'data', 'pl', '*'))
