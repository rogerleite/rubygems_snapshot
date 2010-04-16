require 'rubygems/command_manager'
require 'commands/snapshot_command'

require "gems_snapshot/exporter"

Gem::CommandManager.instance.register_command :snapshot

