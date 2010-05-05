require "fileutils"

OUTPUT = 'tmp/output.log'
SHOW_OUTPUT = !!ENV["show_output"]
#rake cucumber show_output=true  #to show output

Before do
  FileUtils.rm_f OUTPUT
  FileUtils.mkdir_p File.dirname(OUTPUT)
end

#execute system command, redirecting output
def execute(command)
  #2>&1 Redirect standard error to standard output
  system("#{command} > #{OUTPUT} 2>&1")
  puts File.read(OUTPUT) if SHOW_OUTPUT
end

#read output
def output
  File.read(OUTPUT)
end

#Change some commands if necessary
def gsub_command(system_command)
  command = system_command
  if system_command =~ /^gem/
    command << " --config-file=features/resources/gem-cucumber.yml"
  end
  command
end
