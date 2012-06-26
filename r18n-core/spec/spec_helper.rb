# encoding: utf-8
require 'pp'

dir = Pathname(__FILE__).dirname

require dir.join('../lib/r18n-core').to_s
Dir.glob(dir.join('../locales/*.rb').to_s) { |locale| require locale }

TRANSLATIONS = dir + 'translations' unless defined? TRANSLATIONS
DIR = TRANSLATIONS + 'general' unless defined? DIR
TWO = TRANSLATIONS + 'two'     unless defined? TWO
EXT = R18n::Loader::YAML.new(TRANSLATIONS + 'extension') unless defined? EXT

RSpec.configure do |config|
  config.before { R18n.clear_cache! }
end

gem 'kramdown'
gem 'RedCloth'

class CounterLoader
  attr_reader :available
  attr_reader :loaded

  def initialize(*available)
    @available = available.map { |i| R18n.locale(i) }
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

if '1.8.' != RUBY_VERSION[0..3]
  YAML::ENGINE.yamler = ENV['test_syck'] ? 'syck' : 'psych'
end
