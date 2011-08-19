#!/usr/bin/env ruby

require 'rubygems'
gem 'rbench'
require 'rbench'

YAML::ENGINE.yamler = 'psych' if 'psych' == ARGV.first

require 'pathname'
dir = Pathname.new(__FILE__).dirname.expand_path

begin
  require dir + '../r18n-core/lib/r18n-core'
rescue LoadError
  puts "ERROR: Can't load edge R18n. Use from gem."
  gem 'r18n-core'
  require 'r18n-core'
end

gem 'i18n'
require 'i18n'

I18n::Backend::Simple.send(:include, I18n::Backend::Fallbacks)
I18n::Backend::Simple.send(:include, I18n::Backend::Pluralization)
I18n::Backend::Simple.send(:include, I18n::Backend::InterpolationCompiler)
I18n::Backend::Simple.send(:include, I18n::Backend::Flatten)

RBench.run(1000) do
  
  column :r18n, :title => 'R18n'
  column :i18n, :title => 'Rails I18n'
  column :diff, :title => 'I18n/R18n', :compare => [:i18n, :r18n]

  report 'cold load' do
    r18n {
      R18n.cache = {}
      R18n.set(%w{ru fr en}, dir + 'r18n')
      R18n.get.available_locales
    }
    i18n {
      I18n.reload!
      I18n.available_locales = nil
      
      I18n.load_path = [Dir.glob(dir.join('i18n/*.{yml,rb}').to_s)]
      I18n.locale = :ru
      I18n.fallbacks[:ru] = [:ru, :en]
      I18n.available_locales
    }
  end

  report 'load' do
    r18n {
      R18n.set(%w{ru fr en}, dir + 'r18n')
      R18n.get.available_locales
    }
    i18n {
      I18n.locale = :ru
      I18n.fallbacks[:ru] = [:ru, :en]
      I18n.available_locales
    }
  end

  report 'get' do
    r18n {
      R18n.get.user.name
      R18n.get.users.new.title
    }
    i18n {
      I18n.t :'user.name'
      I18n.t :'users.new.title'
    }
  end

  report 'variables' do
    r18n {
      R18n.get.user.your_name('John', 'user123')
    }
    i18n {
      I18n.t :'user.your_name', :name => 'John', :login => 'user123'
    }
  end

  report 'pluralize' do
    r18n {
      R18n.get.user.count(51)
    }
    i18n { 
      I18n.t :'user.count', :count => 51
    }
  end

  report 'localize' do
    r18n {
      R18n.get.l Time.now
    }
    i18n {
      I18n.l Time.now
    }
  end

  report 'default' do
    r18n {
      R18n.get.not.exists | 'default'
      R18n.get.not.exists | R18n.get.user.name
    }
    i18n {
      I18n.t :'not.exists', :default => 'default'
      I18n.t :'not.exists', :default => :'user.name'
    }
  end

  report 'fallback' do
    r18n {
      R18n.get.users.edit.title
    }
    i18n {
      I18n.t :'users.edit.title'
    }
  end

end
