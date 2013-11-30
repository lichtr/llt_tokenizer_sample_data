require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

desc 'Runs the main script'
task :run do
  ruby "script/run.rb"
end

desc 'Profile code'
task :prof do
  ruby "script/prof.rb"
end

task :default => :run
