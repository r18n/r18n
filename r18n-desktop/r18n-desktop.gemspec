require '../r18n-core/lib/r18n-core/version'
require 'rake'

Gem::Specification.new do |s|
  s.platform = Gem::Platform::RUBY
  s.name = 'r18n-desktop'
  s.version = R18n::VERSION
  s.summary = 'A i18n tool to translate your Ruby desktop application.'
  s.description = <<-EOF
    A i18n tool to translate your desktop application in several languages.
    It is just a wrapper for R18n core library.
    It has nice Ruby-style syntax, filters, flexible locales, custom loaders,
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
  
  s.author = 'Andrey "A.I." Sitnik'
  s.email = 'andrey@sitnik.ru'
  s.homepage = 'http://r18n.rubyforge.org/'
  s.rubyforge_project = 'r18n-desktop'
end

