# frozen_string_literal: true

require File.expand_path('../lib/r18n-core/version', __FILE__)

Gem::Specification.new do |s|
  s.platform = Gem::Platform::RUBY
  s.name     = 'r18n-core'
  s.version  = R18n::VERSION.dup
  s.date     = Time.now.strftime('%Y-%m-%d')

  s.summary     = 'I18n tool to translate your Ruby application.'
  s.description = <<-DESC
    R18n is a i18n tool to translate your Ruby application.
    It has nice Ruby-style syntax, filters, flexible locales, custom loaders,
    translation support for any classes, time and number localization, several
    user language support, agnostic core package with out-of-box support for
    Rails, Sinatra and desktop applications.
  DESC

  s.files            = `git ls-files`.split("\n")
  s.test_files       = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.extra_rdoc_files = ['README.md', 'LICENSE', 'ChangeLog.md']
  s.require_path     = 'lib'

  s.author   = 'Andrey Sitnik'
  s.email    = 'andrey@sitnik.ru'
  s.homepage = 'https://github.com/ai/r18n'
  s.license  = 'LGPL-3'
end
