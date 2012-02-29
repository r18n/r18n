# encoding: utf-8

require 'rubygems'

begin
  require 'bundler/setup'
rescue LoadError
  puts "Bundler not available. Install it with: gem install bundler"
end

GEMS = %w{r18n-core r18n-desktop sinatra-r18n r18n-rails-api r18n-rails}.freeze

task :default => :spec

def each_gem(&block)
  GEMS.each do |dir|
    Dir.chdir(dir, &block)
  end
end

def rake(task)
  sh "#{Rake::DSL::RUBY} -S bundle exec rake #{task}", :verbose => false
end

def each_rake(task)
  each_gem { rake task }
end

require 'rspec/core/rake_task'
GEMS.each do |gem|
  RSpec::Core::RakeTask.new("spec_#{gem}") do |task|
    task.pattern = "./#{gem}/spec{,/*/**}/*_spec.rb"
  end
end

desc 'Run all specs'
task :spec => (GEMS.map { |i| "spec_#{i}" })

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
