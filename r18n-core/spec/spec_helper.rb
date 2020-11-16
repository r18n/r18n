# frozen_string_literal: true

require 'pp'
require 'pry-byebug'

require 'active_support'

require_relative '../lib/r18n-core'

shared_context 'common core directories' do
  let(:translations_dir) { File.join(__dir__, 'translations') }
  let(:general_translations_dir) { File.join(translations_dir, 'general') }
  let(:two_translations_dir) { File.join(translations_dir, 'two') }
  let(:ext_translations_dir) do
    R18n::Loader::YAML.new(File.join(translations_dir, 'extension'))
  end
end

RSpec.configure do |config|
  config.before { R18n.clear_cache! }
  config.include_context 'common core directories'
end

gem 'kramdown'
gem 'RedCloth'

class CounterLoader
  attr_reader :available, :loaded

  def initialize(*available)
    @available = available.map { |i| R18n.locale(i) }
    @loaded = 0
  end

  def load(_locale)
    @loaded += 1
    {}
  end

  def hash
    @available.hash
  end
end
