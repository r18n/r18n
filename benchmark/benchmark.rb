#!/usr/bin/env ruby

require 'rubygems'
require 'rbench'

begin
  require '../r18n-core/lib/r18n-core'
rescue LoadError
  puts "ERROR: Can't load edge R18n. Use from gem."
  require 'r18n-core'
end

require 'i18n'

I18n::Backend::Simple.send(:include, I18n::Backend::Fallbacks)
I18n.fallbacks[:ru] = [:en]

RBench.run(1000) do
  
  column :r18n, :title => 'R18n'
  column :i18n, :title => 'Rails I18n'
  column :diff, :title => 'R18n/I18n', :compare => [:r18n, :i18n]

  report 'load' do
    r18n {
      R18n.set R18n::I18n.new(%w{ru en}, './r18n')
      R18n.get.translations
    }
    i18n {
      I18n.reload!
      I18n.available_locales = nil
      
      I18n.load_path = [Dir.glob('./i18n/*.yml')]
      I18n.locale = :ru
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
      R18n.get.user.count(53)
    }
    i18n {
      I18n.t :'user.count', :count => 53
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
