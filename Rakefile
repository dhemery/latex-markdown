gemname = 'dbp-book_compiler'
require_relative 'lib/dbp/compile/version'

gemspec = "#{gemname}.gemspec"
gemfile = "#{gemname}-#{DBP::Compile::VERSION::STRING}.gem"

require 'rake/clean'
require 'rake/testtask'

desc "Build the #{gemname} gem"
task build: [:test] do
  sh 'gem', 'build', gemspec
end

desc "Install the #{gemname} gem"
task install: [:build] do
  sh 'gem', 'install', '--local', gemfile
end

desc "Uninstall the #{gemname} gem"
task :uninstall do
  sh 'gem', 'uninstall', '-a', '-x', gemname
end

desc 'Run all tests'
Rake::TestTask.new do |t|
  t.pattern = 'spec/**/*_spec.rb'
end

task default: :test

CLOBBER.include gemfile
