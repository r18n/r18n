require '../r18n-core/lib/r18n-core/version'

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
    Rails, Sinatra, Merb and desktop applications.
  EOF

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.extra_rdoc_files = ['README.rdoc', 'LICENSE']
  s.require_path = 'lib'
  s.has_rdoc = true

  s.author = 'Andrey "A.I." Sitnik'
  s.email = 'andrey@sitnik.ru'
  s.homepage = 'http://r18n.rubyforge.org/'
  s.rubyforge_project = 'r18n-rails'

  s.add_dependency 'r18n-rails-api', ["= #{R18n::VERSION}"]

  s.add_development_dependency "bundler", [">= 1.0.10"]
  s.add_development_dependency "hanna", [">= 0"]
  s.add_development_dependency "rake", [">= 0", "!= 0.9.0"]
  s.add_development_dependency "rails", [">= 3"]
  s.add_development_dependency "rspec", [">= 2"]
  s.add_development_dependency "rspec-rails", [">= 2"]
  s.add_development_dependency "rcov", [">= 0"]
end

