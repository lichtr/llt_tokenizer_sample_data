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
  exec 'pprof.rb --gif profiling/segtok > profiling/segtok.gif;
        pprof.rb --gif profiling/xml > profiling/xml.gif;
        xdg-open profiling/segtok.gif;
        xdg-open profiling/xml.gif'
end

task :default => :run
