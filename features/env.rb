require "features/env_terminal"

def create_fake_environment
  puts "\n=== Building fake environment ... \n"

  root_dir = File.expand_path( File.dirname(__FILE__) + "/.." )
  puts "Project Root Directory: #{root_dir}"

  ENV["GEM_HOME"]="#{root_dir}/tmp/fake_gems"
  ENV["GEM_PATH"]="#{root_dir}/tmp/fake_gems"

  FileUtils.rm_rf "tmp"
  FileUtils.mkdir_p "tmp/fake_gems"

  system <<CMD
  mkdir tmp/gems
  cp features/resources/*.sample tmp/gems
  cd tmp/gems
  rename 's/\.sample$//' *.sample
  cd ../..
  cp features/resources/*.tar tmp/
CMD

  system "gem install tmp/gems/rake-0.8.7.gem --no-ri --no-rdoc > /dev/null"

  system "gem build rubygems_snapshot.gemspec"
  system "gem install rubygems_snapshot*.gem --no-ri --no-rdoc > /dev/null"

  system "gem env"
  system "gem list"
  
  puts "\n=== Fake environment done! \n\n"
end

create_fake_environment
