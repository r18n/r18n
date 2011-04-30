# encoding: utf-8

require 'rubygems'

GEMS = %w[ r18n-core r18n-desktop sinatra-r18n r18n-rails-api r18n-rails ].freeze

task :default => :spec

def rake(task)
  sh "rake #{task}", :verbose => false
end

def each_rake(task)
  GEMS.each do |dir|
    Dir.chdir(dir) { rake task }
  end
end

def bundle(task)
  sh "bundle #{task}", :verbose => false
end

def each_bundle(task)
  GEMS.each do |dir|
    Dir.chdir(dir) { bundle task }
  end
end

desc 'Run specs'
task :spec  => :bundle do
  each_rake 'spec'
end

desc 'Build the gem files'
task :build => :bundle do
  each_rake 'build'
end

task :clobber => :bundle do
  rm_r 'log' if File.exists? 'log'
  each_rake 'clobber'
end

desc 'Run bundle install'
task :bundle do
  each_bundle 'install'
end

