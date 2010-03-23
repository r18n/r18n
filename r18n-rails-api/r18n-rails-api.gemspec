require '../r18n-core/lib/r18n-core/version'
require 'rake'

Gem::Specification.new do |s|
  s.platform = Gem::Platform::RUBY
  s.name = 'r18n-rails-api'
  s.version = R18n::VERSION
  s.summary = 'Rails I18n compatibility for R18n'
  s.description = <<-EOF
    R18n backend for Rails I18n and R18n filters and loader to support Rails
    translation format.
    R18n has nice Ruby-style syntax, filters, flexible locales, custom loaders,
    translation support for any classes, time and number localization, several
    user language support, agnostic core package with out-of-box support for
    Rails, Sinatra, Merb and desktop applications.
  EOF
  
  s.files = FileList[
    'lib/**/*',
    'LICENSE',
    'README.rdoc']
  s.test_files = FileList[
    'spec/**/*']
  s.extra_rdoc_files = ['README.rdoc', 'LICENSE']
  s.require_path = 'lib'
  s.has_rdoc = true
  
  s.add_dependency 'r18n-core', R18n::VERSION
  s.add_dependency 'i18n'
  
  s.author = 'Andrey "A.I." Sitnik'
  s.email = 'andrey@sitnik.ru'
  s.homepage = 'http://r18n.rubyforge.org/'
  s.rubyforge_project = 'r18n-rails-api'
end
