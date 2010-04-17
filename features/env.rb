require "fileutils"

OUTPUT = 'tmp/output.log'

Before do
  FileUtils.rm_rf OUTPUT
  FileUtils.mkdir_p File.dirname(OUTPUT)
end

#execute system command, redirecting output
def execute(command)
  system("#{command} > #{OUTPUT}")
end

#read output
def output
  File.read(OUTPUT)
end

#Change some commands if necessary
def gsub_command(system_command)
  command = system_command
  if system_command.include?("gem ")
    command.gsub!("gem ", "ruby -I ./lib/ `which gem` ")
  end
  command
end

