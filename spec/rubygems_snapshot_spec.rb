require "rubygems"
require "rubygems_plugin"

describe "RubygemsSnapshot" do

  def create_command(options = {})
    cmd = Gem::Commands::SnapshotCommand.new
    cmd.stub!(:options).and_return(options)
    cmd.stub!(:say)
    cmd
  end

  it "should validate no action argument" do
    empty_args = {:args => []}
    cmd = create_command(empty_args)
    
    lambda { cmd.execute }.should raise_error(Gem::CommandLineError)
  end

  it "should validate invalid action argument" do
    empty_args = {:args => ["invalid_action"]}
    cmd = create_command(empty_args)
    
    lambda { cmd.execute }.should raise_error(Gem::CommandLineError)
  end

  describe "when exporting gems ..." do

    it "should works" do
      cmd = create_command({:args => ["export", "./spec/export_sample"]})

      cmd.stub!(:list_installed_gems).and_return do
        [OpenStruct.new({:name => "example1", :version => "1.0.0"}),
        OpenStruct.new({:name => "example2", :version => "1.1.5"})]
      end

      Gem.stub!(:sources).and_return do
        ["http://server1.org", "http://server2.org"]
      end

      cmd.execute

      result_file = File.expand_path("./spec/export_sample.yml")
      File.exist?(result_file).should eql(true)

      expected_yml = <<-TXT
--- 
sources: 
- http://server1.org
- http://server2.org
gems: 
- name: example1
  versions: 
  - 1.0.0
- name: example2
  versions: 
  - 1.1.5
      TXT

      File.read(result_file).should eql(expected_yml)
      File.delete(result_file)
    end

  end

  describe "when importing gems ..." do
    
    it "should validate if filename argument is not empty" do
      args = {:args => ["import"]}
      cmd = create_command(args)
      
      lambda { cmd.execute }.should raise_error(Gem::CommandLineError)
    end

    it "should validate if filename argument exist" do
      args = {:args => ["import", "./spec/invalid_file.yml"]}
      cmd = create_command(args)
      
      lambda { cmd.execute }.should raise_error(Gem::Exception)
    end
    
    it "should works" do
      sample_yml = <<-TXT
--- 
sources: 
- http://server1.org
- http://server2.org
gems: 
- name: example1
  versions: 
  - 1.0.0
- name: example2
  versions: 
  - 1.1.5
      TXT

      File.open(File.expand_path("./spec/import_sample.yml"), "w") do |f|
        f.puts(sample_yml)
      end

      cmd = create_command({:args => ["import", "./spec/import_sample.yml"]})
      cmd.should_receive(:gem_install).with(an_instance_of(Hash), "example1", "1.0.0")
      cmd.should_receive(:gem_install).with(an_instance_of(Hash), "example2", "1.1.5")
      
      cmd.execute
      Gem.sources.include?("http://server1.org").should eql(true)
      Gem.sources.include?("http://server2.org").should eql(true)
      
      File.delete(File.expand_path("./spec/import_sample.yml"))
    end
    
  end

end

