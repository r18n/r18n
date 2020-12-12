# frozen_string_literal: true

require_relative '../r18n-core/lib/r18n-core/version'

Gem::Specification.new do |s|
  s.platform = Gem::Platform::RUBY
  s.name     = 'r18n-desktop'
  s.version  = R18n::VERSION.dup
  s.date     = Time.now.strftime('%Y-%m-%d')

  s.summary     = 'A i18n tool to translate your Ruby desktop application.'
  s.description = <<-DESC
    A i18n tool to translate your desktop application in several languages.
    It is just a wrapper for R18n core library.
    It has nice Ruby-style syntax, filters, flexible locales, custom loaders,
    translation support for any classes, time and number localization, several
    user language support, agnostic core package with out-of-box support for
    Rails, Sinatra and desktop applications.
  DESC

  s.files            = `git ls-files`.split("\n")
  s.test_files       = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.extra_rdoc_files = ['README.md', 'LICENSE']
  s.require_path     = 'lib'

  s.author   = 'Andrey Sitnik'
  s.email    = 'andrey@sitnik.ru'
  s.homepage = 'https://github.com/r18n/r18n/tree/master/r18n-desktop'
  s.license  = 'LGPL-3.0'

  s.required_ruby_version = '~> 2.5'

  s.add_dependency 'r18n-core', "= #{R18n::VERSION}"
end
