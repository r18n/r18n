# frozen_string_literal: true

require 'pp'
require 'pry-byebug'

ENV['RACK_ENV'] = 'test'
require_relative 'app/app'

require 'rack/test'

module RSpecMixinExample
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end
end

RSpec.configure { |c| c.include RSpecMixinExample }

set :environment, :test
set :root, File.join(File.dirname(__FILE__), 'app')
