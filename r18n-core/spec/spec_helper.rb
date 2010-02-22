# encoding: utf-8
require 'rubygems'
require 'pp'

dir = Pathname(__FILE__).dirname

require dir + '../lib/r18n-core'

TRANSALTIONS = dir + 'translations'
DIR = TRANSALTIONS + 'general' unless defined? DIR
TWO = TRANSALTIONS + 'two' unless defined? TWO
EXT = R18n::Loader::YAML.new(TRANSALTIONS + 'extension') unless defined? EXT

Spec::Runner.configure do |config|
  config.before { R18n.cache.clear }
end

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
