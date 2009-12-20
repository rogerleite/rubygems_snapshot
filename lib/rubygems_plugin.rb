#$:.unshift File.dirname(__FILE__)     # For use/testing when no gem is installed

require 'rubygems/command_manager'

require "commands/snapshot_command"
Gem::CommandManager.instance.register_command :snapshot

