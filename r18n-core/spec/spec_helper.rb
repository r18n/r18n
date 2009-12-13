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

class CounterLoader
  attr_reader :available
  attr_reader :loaded
  
  def initialize(*available)
    @available = available.map { |i| R18n::Locale.load(i) }
    @loaded = 0
  end
  
  def load(locale)
    @loaded += 1
    {}
  end
  
  def hash
    @available.hash
  end
end
