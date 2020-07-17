require 'rake'
require 'rubygems/package_task'
 
GEM = "rubygems_snapshot"
GEM_VERSION = "0.3.0"
SUMMARY = "Command to import/export gems"
DESCRIPTION = "Adds snapshot command to gem. This command allow import/export of gems."
AUTHOR = "Roger Leite"
EMAIL = "roger.barreto@gmail.com"
HOMEPAGE = "http://github.com/rogerleite/rubygems_snapshot"

 
spec = Gem::Specification.new do |s|
  s.name = GEM
  s.version = GEM_VERSION
  s.platform = Gem::Platform::RUBY
  s.summary = SUMMARY
  s.description = DESCRIPTION
  s.require_paths = ["lib"]
  s.files = FileList['lib/**/*', 'README*'].to_a
  
  s.author = AUTHOR
  s.email = EMAIL
  s.homepage = HOMEPAGE

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.5") if s.respond_to? :required_rubygems_version=

  s.post_install_message = <<MESSAGE
===============================================================================
  Thanks for installing RubygemsSnapshot! You can now run:
  gem snapshot export example
  gem snapshot import example
  ***
  gem help snapshot for help! ;)
  OR http://github.com/rogerleite/rubygems_snapshot
===============================================================================
MESSAGE
end

Gem::PackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end
 
desc "Install the gem locally"
task :install => [:package] do
  sh %{sudo gem install pkg/#{GEM}-#{GEM_VERSION}}
end
 
desc "Create a gemspec file"
task :make_spec do
  File.open("#{GEM}.gemspec", "w") do |file|
    file.puts spec.to_ruby
  end
end

Dir["tasks/*.rake"].each do |rake_file|
  load rake_file
end
