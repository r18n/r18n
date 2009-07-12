# encoding: utf-8
require 'rubygems'
gem 'rspec'
require 'spec/rake/spectask'

GEMS = %w[ r18n-core r18n-desktop sinatra-r18n ]

task :default => :spec

def rake(task)
  sh "#{RUBY} -S rake #{task}", :verbose => false
end

def each_rake(task)
  GEMS.each do |dir|
    Dir.chdir(dir) { rake task }
  end
end

Spec::Rake::SpecTask.new('spec') do |t|
  t.libs << 'r18n-core/lib/'
  t.spec_opts = ['--format', 'progress', '--colour']
  t.spec_files = []
  GEMS.each do |gem|
    t.spec_files << Dir[gem + '/spec/**/*_spec.rb'].sort
  end
end

desc 'Build the gem files'
task :gem do
  each_rake 'gem'
end

task :clobber do
  rm_r 'log' if File.exists? 'log'
  each_rake 'clobber'
end
