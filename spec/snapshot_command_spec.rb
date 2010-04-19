require "rubygems"
require "rubygems_plugin"

describe Gem::Commands::SnapshotCommand do

  def create_command(options = {})
    #simulates the original array "args"
    options[:args].each { |arg| arg.freeze if arg.respond_to?(:freeze) } if options[:args]
    options[:format] = "tar" unless options[:format]

    cmd = subject
    cmd.stub!(:options).and_return(options)
    cmd.stub!(:say)
    cmd
  end

  it "should validate no action argument" do
    cmd = create_command(:args => [])
    lambda { cmd.execute }.should raise_error(Gem::CommandLineError)
  end

  it "should validate invalid action argument" do
    cmd = create_command(:args => ["invalid_action"])
    lambda { cmd.execute }.should raise_error(Gem::CommandLineError)
  end

  it "should validate invalid format argument" do
    cmd = create_command(:args => ["export", "testfile"], :format => "XXX")
    lambda { cmd.execute }.should raise_error(Gem::CommandLineError)
  end

  describe "when exporting gems ..." do

    it "should validate if filename argument is not empty" do
      cmd = create_command(:args => ["export"])
      lambda { cmd.execute }.should raise_error(Gem::CommandLineError)
    end

    it "should call Exporter API" do
      cmd = create_command(:args => ["export", "./spec/export_sample"])
      GemsSnapshot::Exporter.should_receive(:export).with("./spec/export_sample", :format => "tar").and_return("./spec/export_sample")

      cmd.execute
    end

  end

  describe "when importing gems ..." do
    
    it "should validate if filename argument is not empty" do
      cmd = create_command(:args => ["import"])
      
      lambda { cmd.execute }.should raise_error(Gem::CommandLineError)
    end

    it "should validate if filename argument exist" do
      cmd = create_command(:args => ["import", "./spec/invalid_file.yml"])
      
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

      cmd = create_command(:args => ["import", "./spec/import_sample.yml"])
      cmd.should_receive(:gem_install).with(an_instance_of(Hash), "example1", "1.0.0")
      cmd.should_receive(:gem_install).with(an_instance_of(Hash), "example2", "1.1.5")
      
      cmd.execute
      Gem.sources.include?("http://server1.org").should eql(true)
      Gem.sources.include?("http://server2.org").should eql(true)
      
      File.delete(File.expand_path("./spec/import_sample.yml"))
    end
    
  end

end

