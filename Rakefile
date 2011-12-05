# encoding: utf-8

require 'rubygems'

GEMS = %w{r18n-core r18n-desktop sinatra-r18n r18n-rails-api r18n-rails}.freeze

task :default => :spec

def each_gem(&block)
  GEMS.each do |dir|
    Dir.chdir(dir, &block)
  end
end

def rake(task)
  sh "bundle exec rake #{task}", :verbose => false
end

def each_rake(task)
  each_gem { rake task }
end

desc 'Run specs'
task :spec do
  each_rake 'spec'
end

desc 'Release to rubygems'
task :release => [:clobber, :gemfile, :build] do
  each_gem { sh 'gem push `ls pkg/*`' }
end

task :build do
  each_rake 'build'
end

task :clobber do
  rm_r 'log' if File.exists? 'log'
  each_rake 'clobber'
end

task :gemfile do
  each_gem { sh 'bundle install' }
end
