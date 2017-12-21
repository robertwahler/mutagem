# encoding: utf-8

# bundler/setup is managing $LOAD_PATH, any gem needed by this Rakefile must
# be listed as a development dependency in the gemspec

require 'rubygems'
require 'bundler/setup'

Bundler::GemHelper.install_tasks

def gemspec
  @gemspec ||= begin
    file = File.expand_path('../mutagem.gemspec', __FILE__)
    eval(File.read(file), binding, file)
  end
end

require 'spec'
require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

require 'cucumber'
require 'cucumber/rake/task'
Cucumber::Rake::Task.new(:features) do |task|
  task.cucumber_opts = ["features"]
end

desc "Run specs and features"
task :test => [:spec, :features]

task :default => :test