if defined? Merb::Plugins
  dependency 'merb-slices', '~> 1.0'
  Merb::Slices::register(__FILE__)
  
  module Slice
    self.description = 'Test i18n for slices'
    self.version = '0.0.1'
    self.author = 'Andrey A.I. Sitnik'
    
    def self.loaded; end
    def self.activate; end
    def self.deactivate; end
    
    def self.setup_router(scope)
      scope.default_routes
    end
  end
  
  require File.dirname(__FILE__) / '../application'
end
