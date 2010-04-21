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
    
    it "should call Importer API" do
      cmd = create_command(:args => ["import", "./tmp/import_sample"])
      File.open("./tmp/import_sample", "w") { |file| file.puts "sample!" }

      GemsSnapshot::Importer.should_receive(:import).with("./tmp/import_sample", :format => "tar")
      cmd.execute
    end

  end

end

