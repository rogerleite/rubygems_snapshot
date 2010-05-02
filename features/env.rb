require "fileutils"

OUTPUT = 'tmp/output.log'

Before do
  FileUtils.rm_rf OUTPUT
  FileUtils.mkdir_p File.dirname(OUTPUT)
end

def create_fake_environment
  puts "\n=== Building fake environment ... \n"

  root_dir = File.expand_path( File.dirname(__FILE__) + "/.." )
  puts "Project Root Directory: #{root_dir}"

  ENV["GEM_HOME"]="#{root_dir}/tmp/fake_gems"
  ENV["GEM_PATH"]="#{root_dir}/tmp/fake_gems"

  FileUtils.rm_rf "tmp"
  FileUtils.mkdir_p "tmp/fake_gems"

  system "gem install features/resources/rake-0.8.7.gem --no-ri --no-rdoc > /dev/null"

  system "gem build rubygems_snapshot.gemspec"
  system "gem install rubygems_snapshot*.gem --no-ri --no-rdoc > /dev/null"

  system "gem env"
  system "gem list"
  
  puts "\n=== Fake environment done! \n\n"
end

#execute system command, redirecting output
def execute(command)
  #2>&1 Redirect standard error to standard output
  system("#{command} > #{OUTPUT} 2>&1")
end

#read output
def output
  File.read(OUTPUT)
end

#Change some commands if necessary
def gsub_command(system_command)
  command = system_command
  if system_command.include?("gem ")
    #command.gsub!("gem ", "ruby -I ./lib/ `which gem` ")
    command << " --config-file=features/resources/gem-cucumber.yml"
  end
  command
end

create_fake_environment
