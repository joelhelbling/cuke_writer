require 'cucumber/rake/task'
require 'rspec/core/rake_task'
require 'bundler'

task :default => [:rspec_tests, :cucumber_tests]

Cucumber::Rake::Task.new(:cucumber_tests) do |t|
  t.cucumber_opts = ['--no-source']
end

RSpec::Core::RakeTask.new(:rspec_tests) do |t|
  t.rspec_opts = ['--format', 'nested']
end

Bundler::GemHelper.install_tasks
