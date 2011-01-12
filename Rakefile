require 'bundler'
Bundler::GemHelper.install_tasks

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec_on_supported_ruby_versions

task :spec_on_supported_ruby_versions do
  sh "rvm 1.9.2 exec rake spec"
  sh "rvm 1.8.7 exec rake spec"
end
