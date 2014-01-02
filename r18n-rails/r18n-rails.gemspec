require File.expand_path('../../r18n-core/lib/r18n-core/version', __FILE__)

Gem::Specification.new do |s|
  s.platform = Gem::Platform::RUBY
  s.name = 'r18n-rails'
  s.version = R18n::VERSION.dup
  s.date = Time.now.strftime('%Y-%m-%d')
  s.summary = 'R18n for Rails'
  s.description = <<-EOF
    Out-of-box R18n support for Ruby on Rails.
    It is just a wrapper for R18n Rails API and R18n core libraries.
    R18n has nice Ruby-style syntax, filters, flexible locales, custom loaders,
    translation support for any classes, time and number localization, several
    user language support, agnostic core package with out-of-box support for
    Rails, Sinatra and desktop applications.
  EOF

  s.files            = `git ls-files`.split("\n")
  s.test_files       = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.extra_rdoc_files = ['README.md', 'LICENSE']
  s.require_path     = 'lib'

  s.author   = 'Andrey Sitnik'
  s.email    = 'andrey@sitnik.ru'
  s.homepage = 'https://github.com/ai/r18n/tree/master/r18n-rails'
  s.license  = 'LGPL-3'

  s.add_dependency 'r18n-rails-api', "= #{R18n::VERSION}"
end

