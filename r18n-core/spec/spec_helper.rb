# encoding: utf-8
require 'pp'

require File.join(File.dirname(__FILE__), '../lib/r18n-core')

DIR = Pathname(__FILE__).dirname + 'translations/general' unless defined? DIR
TWO = Pathname(__FILE__).dirname + 'translations/two' unless defined? TWO
EXT = Pathname(__FILE__).dirname + 'translations/extension' unless defined? EXT
