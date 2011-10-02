require '../r18n-core/lib/r18n-core/version'

Gem::Specification.new do |s|
  s.platform = Gem::Platform::RUBY
  s.name = 'sinatra-r18n'
  s.version = R18n::VERSION.dup
  s.date = Time.now.strftime('%Y-%m-%d')
  s.summary = 'A Sinatra extension that provides i18n support to translate your
    web application.'
  s.description = <<-EOF
    A Sinatra extension that provides i18n support to translate your web
    application. It is just a wrapper for R18n core library.
    It has nice Ruby-style syntax, filters, flexible locales, custom loaders,
    translation support for any classes, time and number localization, several
    user language support, agnostic core package with out-of-box support for
    Rails, Sinatra, Merb and desktop applications.
  EOF

  s.files            = `git ls-files`.split("\n")
  s.test_files       = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.extra_rdoc_files = ['README.rdoc', 'LICENSE']
  s.require_path = 'lib'

  s.author = 'Andrey "A.I." Sitnik'
  s.email = 'andrey@sitnik.ru'
  s.homepage = 'http://r18n.rubyforge.org/'
  s.rubyforge_project = 'sinatra-r18n'

  s.add_dependency 'sinatra', [">= 1.3"]
  s.add_dependency 'r18n-core', ["= #{R18n::VERSION}"]

  s.add_development_dependency "bundler", [">= 1.0.10"]
  s.add_development_dependency "hanna", [">= 0"]
  s.add_development_dependency "rake", [">= 0", "!= 0.9.0"]
  s.add_development_dependency "rack-test", [">= 0"]
  s.add_development_dependency "rspec-core", [">= 0"]
  s.add_development_dependency "rspec-expectations", [">= 0"]
  s.add_development_dependency "rspec-mocks", [">= 0"]
  s.add_development_dependency "rcov", [">= 0"]
end
