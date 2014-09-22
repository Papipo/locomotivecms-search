#!/usr/bin/env rake

require 'rubygems'
require 'bundler/setup'

require 'rake'
require 'rubygems/package_task'

$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)

require 'locomotive/search/version'

gemspec = eval(File.read('locomotivecms-search-wagon.gemspec'))
Gem::PackageTask.new(gemspec) do |pkg|
  pkg.gem_spec = gemspec
end

desc 'build the gem and release it to rubygems.org'
task release: :gem do
  sh "gem push pkg/locomotivecms-search-wagon-#{gemspec.version}.gem"
end

Bundler::GemHelper.install_tasks