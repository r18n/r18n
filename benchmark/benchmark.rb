#!/usr/bin/env ruby
# frozen_string_literal: true

begin
  require 'bundler/setup'
rescue LoadError
  puts 'Bundler not available. Install it with: gem install bundler'
end

require 'pathname'
dir = Pathname.new(__FILE__).dirname.expand_path

require 'i18n'
require 'rbench'
require 'r18n-core'

I18n.enforce_available_locales = false
I18n::Backend::Simple.send(:include, I18n::Backend::Fallbacks)
I18n::Backend::Simple.send(:include, I18n::Backend::Pluralization)
I18n::Backend::Simple.send(:include, I18n::Backend::InterpolationCompiler)
I18n::Backend::Simple.send(:include, I18n::Backend::Flatten)

class Array
  def nitems
    count { |i| !i.nil? }
  end
end

RBench.run(1000) do
  column :r18n, title: 'R18n'
  column :i18n, title: 'Rails I18n'
  column :diff, title: 'I18n/R18n', compare: %i[i18n r18n]

  report 'cold load' do
    r18n do
      R18n.clear_cache!
      R18n.set(%w[ru fr en], dir + 'r18n')
      R18n.get.available_locales
    end
    i18n do
      I18n.reload!
      I18n.available_locales = nil

      I18n.load_path = [Dir.glob(dir.join('i18n/*.{yml,rb}').to_s)]
      I18n.locale = :ru
      I18n.fallbacks[:ru] = %i[ru en]
      I18n.available_locales
    end
  end

  report 'load' do
    r18n do
      R18n.set(%w[ru fr en], dir + 'r18n')
      R18n.get.available_locales
    end
    i18n do
      I18n.locale = :ru
      I18n.fallbacks[:ru] = %i[ru en]
      I18n.available_locales
    end
  end

  report 'get' do
    r18n do
      R18n.get.user.name
      R18n.get.users.new.title
    end
    i18n do
      I18n.t :'user.name'
      I18n.t :'users.new.title'
    end
  end

  report 'variables' do
    r18n do
      R18n.get.user.your_name('John', 'user123')
    end
    i18n do
      I18n.t :'user.your_name', name: 'John', login: 'user123'
    end
  end

  report 'pluralize' do
    r18n do
      R18n.get.user.count(51)
    end
    i18n do
      I18n.t :'user.count', count: 51
    end
  end

  report 'localize' do
    r18n do
      R18n.get.l Time.now
    end
    i18n do
      I18n.l Time.now
    end
  end

  report 'default' do
    r18n do
      R18n.get.not.exists | 'default'
      R18n.get.not.exists | R18n.get.user.name
    end
    i18n do
      I18n.t :'not.exists', default: 'default'
      I18n.t :'not.exists', default: :'user.name'
    end
  end

  report 'fallback' do
    r18n do
      R18n.get.users.edit.title
    end
    i18n do
      I18n.t :'users.edit.title'
    end
  end
end
