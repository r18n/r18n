# encoding: utf-8
require 'rubygems'
gem 'rspec'
require 'spec/rake/spectask'

GEMS    = %w[ r18n-core r18n-desktop merb_r18n sinatra-r18n ]
RUBY19_GEMS = %w[ r18n-core r18n-desktop ]

task :default => :spec

SUPPORTED_GEMS = RUBY_VERSION >= '1.9.0' ? RUBY19_GEMS : GEMS

def rake(task)
  sh "#{RUBY} -S rake #{task}", :verbose => false
end

def each_rake(task)
  GEMS.each do |dir|
    Dir.chdir(dir) { rake task }
  end
end

Spec::Rake::SpecTask.new('spec') do |t|
  t.spec_opts = ['--format', 'progress', '--colour']
  t.spec_files = []
  SUPPORTED_GEMS.each do |gem|
    t.spec_files << Dir[gem + '/spec/**/*_spec.rb'].sort
  end
end

desc 'Build the gem files'
task :gem do
  each_rake 'gem'
end

task :clobber do
  rm_r 'log'
  each_rake 'clobber'
end
