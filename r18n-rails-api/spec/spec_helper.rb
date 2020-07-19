# frozen_string_literal: true

require 'pp'
require 'pry-byebug'
require 'i18n'
require 'active_support'

I18n.enforce_available_locales = true

require_relative '../lib/r18n-rails-api'

EN   = R18n.locale(:en)
RU   = R18n.locale(:ru)
DECH = R18n.locale(:'de-CH')

shared_context 'common rails api files' do
  let(:general_files) do
    Dir.glob(File.join(__dir__, 'data', 'general', '*'))
  end
  let(:simple_files) do
    Dir.glob(File.join(__dir__, 'data', 'simple', '*'))
  end
  let(:other_files) do
    Dir.glob(File.join(__dir__, 'data', 'other', '*'))
  end
  let(:pl_files) do
    Dir.glob(File.join(__dir__, 'data', 'pl', '*'))
  end
end

RSpec.configure do |config|
  config.before { R18n.clear_cache! }
  config.include_context 'common rails api files'
end
