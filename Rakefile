#require 'rubygems'
#require 'rubygems/specification'

require 'rake'
require 'rake/gempackagetask'
require 'spec/rake/spectask'
 
GEM = "rubygems_snapshot"
GEM_VERSION = "0.1.2"
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
  s.files = FileList['lib/commands/snapshot_command.rb', 'lib/rubygems_plugin.rb', 'README*'].to_a
  
  s.author = AUTHOR
  s.email = EMAIL
  s.homepage = HOMEPAGE

  s.rubyforge_project = GEM # GitHub bug, gem isn't being build when this miss
  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.5") if s.respond_to? :required_rubygems_version=

  s.post_install_message = <<MESSAGE

========================================================================

    Thanks for installing RubygemsSnapshot! You can now run:

    gem snapshot      import/export your gems

========================================================================

MESSAGE
end

Spec::Rake::SpecTask.new do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.spec_opts = %w(-fs --color)
end
  
Rake::GemPackageTask.new(spec) do |pkg|
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
