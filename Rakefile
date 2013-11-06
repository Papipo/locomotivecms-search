#!/usr/bin/env rake
require 'rspec/core/rake_task'

begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end
begin
  require 'rdoc/task'
rescue LoadError
  require 'rdoc/rdoc'
  require 'rake/rdoctask'
  RDoc::Task = Rake::RDocTask
end

RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'LocomotiveSearch'
  rdoc.options << '--line-numbers'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

Bundler::GemHelper.install_tasks

Dir["spec/features/*_spec.rb"].each do |spec_file|
  name = File.basename(spec_file).gsub('_spec.rb', '')
  desc "Run #{name} specs"
  RSpec::Core::RakeTask.new("spec:#{name}") do |t|
    t.pattern = spec_file
  end
end

desc "Run specs"
task spec: Rake.application.tasks.select { |t| t.name.start_with?("spec:") }
task :default => :spec