# encoding: utf-8
require 'rubygems'
gem 'rspec'
require 'spec/rake/spectask'

GEMS = %w[ r18n-core r18n-desktop sinatra-r18n r18n-rails-api r18n-rails ]

task :default => :spec

def rake(task)
  sh "#{RUBY} -S rake #{task}", :verbose => false
end

def each_rake(task)
  GEMS.each do |dir|
    Dir.chdir(dir) { rake task }
  end
end

desc 'Run specs'
task :spec do
  each_rake 'spec'
end

desc 'Build the gem files'
task :gem do
  each_rake 'gem'
end

task :clobber do
  rm_r 'log' if File.exists? 'log'
  each_rake 'clobber'
end
