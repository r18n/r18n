require 'rubygems'
require 'bundler/setup'

GEMS = %w{r18n-core r18n-desktop sinatra-r18n r18n-rails-api r18n-rails}.freeze

def each_gem(&block)
  GEMS.each do |dir|
    Dir.chdir(dir, &block)
  end
end

def rake(task)
  sh "#{Rake::DSL::RUBY} -S bundle exec rake #{task}", verbose: false
end

def each_rake(task)
  each_gem { rake task }
end

desc 'Run all specs'
task :spec do
  each_rake 'spec'
end
task :default => :spec

desc 'Build gems and push thems to RubyGems'
task :release => [:clobber, :build] do
  each_gem { sh 'gem push `ls pkg/*`' }
  each_rake 'clobber'
end

desc 'Remove all generated files'
task :clobber do
  rm_r 'log' if File.exists? 'log'
  each_rake 'clobber'
end

task :build do
  each_rake 'build'
end
