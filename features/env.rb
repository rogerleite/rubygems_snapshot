require "fileutils"

OUTPUT = 'tmp/output.log'

Before do
  FileUtils.rm_rf OUTPUT
  FileUtils.mkdir_p File.dirname(OUTPUT)
end

def create_fake_environment
  ENV["GEM_HOME"]="/home/roger/ruby/rubygems_snapshot/tmp/fake_gems"
  ENV["GEM_PATH"]="/home/roger/ruby/rubygems_snapshot/tmp/fake_gems"

  FileUtils.rm_rf "tmp/fake_gems"
  FileUtils.cp_r "fake_environment/", "tmp/fake_gems"
  system "gem env"
  system "gem list"
  
  system "gem build rubygems_snapshot.gemspec"
  system "gem install rubygems_snapshot*.gem"

  puts "===\n\n"
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
#  if system_command.include?("gem ")
#    command.gsub!("gem ", "ruby -I ./lib/ `which gem` ")
#  end
  command
end

create_fake_environment
