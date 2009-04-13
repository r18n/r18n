# encoding: utf-8
require 'rubygems'

GEM_PATHS = %w[ r18n-core r18n-desktop merb_r18n ]

def rake(task)
  sh "#{RUBY} -S rake #{task}", :verbose => false
end

def each_rake(task)
  GEM_PATHS.each do |dir|
    Dir.chdir(dir) { rake task }
  end
end

task :default => :gem

desc 'Build the gem files'
task :gem do
  each_rake 'gem'
end

task :clobber do
  each_rake 'clobber'
end
