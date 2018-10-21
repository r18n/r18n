# frozen_string_literal: true

## https://github.com/stevekinney/pizza/issues/103#issuecomment-136052789
## https://github.com/docker-library/ruby/issues/45
Encoding.default_external = 'UTF-8'

require 'pp'

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
