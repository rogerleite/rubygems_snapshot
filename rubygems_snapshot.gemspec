# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rubygems_snapshot}
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.5") if s.respond_to? :required_rubygems_version=
  s.authors = ["Roger Leite"]
  s.date = %q{2010-05-06}
  s.description = %q{Adds snapshot command to gem. This command allow import/export of gems.}
  s.email = %q{roger.barreto@gmail.com}
  s.files = ["lib/commands", "lib/commands/snapshot_command.rb", "lib/gems_snapshot", "lib/gems_snapshot/importer", "lib/gems_snapshot/importer/tar_importer.rb", "lib/gems_snapshot/importer/yml_importer.rb", "lib/gems_snapshot/exporter", "lib/gems_snapshot/exporter/tar_exporter.rb", "lib/gems_snapshot/exporter/yml_exporter.rb", "lib/gems_snapshot/exporter.rb", "lib/gems_snapshot/importer.rb", "lib/rubygems_plugin.rb", "README.textile"]
  s.homepage = %q{http://github.com/rogerleite/rubygems_snapshot}
  s.post_install_message = %q{===============================================================================
  Thanks for installing RubygemsSnapshot! You can now run:
  gem snapshot export example
  gem snapshot import example
  ***
  gem help snapshot for help! ;)
  OR http://github.com/rogerleite/rubygems_snapshot
===============================================================================
}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{rubygems_snapshot}
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{Command to import/export gems}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
