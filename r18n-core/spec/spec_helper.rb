# encoding: utf-8
require 'rubygems'
require 'pp'

dir = Pathname(__FILE__).dirname

require dir + '../lib/r18n-core'

DIR = dir + 'translations/general' unless defined? DIR
TWO = dir + 'translations/two' unless defined? TWO
EXT = R18n::Loader::YAML.new(dir + 'translations/extension') unless defined? EXT

gem 'maruku'
gem 'RedCloth'
