#!/usr/bin/env ruby

require 'rubygems'
require 'rake'
require 'rake/testtask'
require 'rubygems/package_task'

task :default => 'test'

Rake::TestTask.new(:test) do |t|
  t.libs << '.' << 'lib' << 'test'
  t.pattern = 'test/legacyliquid/**/*_test.rb'
  t.verbose = false
end

gemspec = eval(File.read('legacyliquid.gemspec'))
Gem::PackageTask.new(gemspec) do |pkg|
  pkg.gem_spec = gemspec
end

desc "Build the gem and release it to rubygems.org"
task :release => :gem do
  sh "gem push pkg/legacyliquid-#{gemspec.version}.gem"
end

namespace :benchmark do

  desc "Run the liquid benchmark"
  task :run do
    ruby "performance/benchmark.rb"
  end

end


namespace :profile do

  desc "Run the liquid profile/performance coverage"
  task :run do
    ruby "performance/profile.rb"
  end

  desc "Run KCacheGrind"
  task :grind => :run  do
    system "kcachegrind /tmp/legacyliquid.rubyprof_calltreeprinter.txt"
  end

end

desc "Run example"
task :example do
  ruby "-w -d -Ilib example/server/server.rb"
end
