require 'rake/clean'
require 'rake/testtask'

task default: :test

desc 'Run all tests'
Rake::TestTask.new do |t|
  t.pattern = 'spec/**/*_spec.rb'
end
