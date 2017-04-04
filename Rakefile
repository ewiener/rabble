require 'rubygems/package_task'
require 'bundler/gem_tasks'

spec = Gem::Specification.load "rabble.gemspec"

Gem::PackageTask.new(spec) do |pkg|
end

desc "Install the gem locally"
task :install => :gem do
  Dir.chdir(File.dirname(__FILE__)) do
    sh %{gem install --local pkg/#{spec.name}-#{spec.version}.gem}
  end
end
