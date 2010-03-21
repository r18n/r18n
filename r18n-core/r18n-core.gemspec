require '../r18n-core/lib/r18n-core/version'
require 'rake'

Gem::Specification.new do |s|
  s.platform = Gem::Platform::RUBY
  s.name = 'r18n-core'
  s.version = R18n::VERSION
  s.summary = 'I18n tool to translate your Ruby application.'
  s.description = <<-EOF
    R18n is a i18n tool to translate your Ruby application.
    It has nice Ruby-style syntax, filters, flexible locales, custom loaders,
    translation support for any classes, time and number localization, several
    user language support, agnostic core package with out-of-box support for
    Rails, Sinatra, Merb and desktop applications.
  EOF

  s.files = FileList[
    'base/**/*',
    'lib/**/*',
    'locales/**/*',
    'LICENSE',
    'ChangeLog',
    'README.rdoc']
    s.test_files = FileList[
      'spec/**/*']
      s.extra_rdoc_files = ['README.rdoc', 'LICENSE', 'ChangeLog']
      s.require_path = 'lib'
      s.has_rdoc = true

      s.author = 'Andrey "A.I." Sitnik'
      s.email = 'andrey@sitnik.ru'
      s.homepage = 'http://r18n.rubyforge.org/'
      s.rubyforge_project = 'r18n-core'
end
