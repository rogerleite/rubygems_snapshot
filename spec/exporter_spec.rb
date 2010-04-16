require "gems_snapshot/exporter"

require "ostruct"
require "fileutils"

include GemsSnapshot

describe GemsSnapshot::Exporter do

  FAKE_GEM_PATH = "#{Dir.tmpdir}/fake_path"

  before :each do
    @mock_gems = [ OpenStruct.new(:installation_path => FAKE_GEM_PATH, :full_name => "rake-0.8.7", :name => "rake", :version => "0.8.7"),
                   OpenStruct.new(:installation_path => FAKE_GEM_PATH, :full_name => "rspec-1.3.0", :name => "rspec", :version => "1.3.0") ]
  end

  it "should support tar format" do
    mock_exporter = Object.new
    TarExporter.should_receive(:new).and_return(mock_exporter)
    mock_exporter.should_receive(:export).with("test.gems").and_return("result_file")

    result_file = Exporter.export("test.gems", :format => :tar)
    result_file.should == "result_file"
  end

  it "should support yml format" do
    mock_exporter = Object.new
    YmlExporter.should_receive(:new).and_return(mock_exporter)
    mock_exporter.should_receive(:export).with("test.yml").and_return("result_file")

    result_file = Exporter.export("test.yml", :format => :yml)
    result_file.should == "result_file"
  end

  describe GemsSnapshot::TarExporter do

    def create_fake_gem_cache_directory
      #create fake gem cache directory and fake gem files
      FileUtils.mkdir_p "#{FAKE_GEM_PATH}/cache"
      @mock_gems.each do |gem|
        File.open("#{FAKE_GEM_PATH}/cache/#{gem.full_name}.gem", "w") { |f| f.write gem.full_name }
      end
    end

    it "should export all installed gems to 'tar' format" do
      create_fake_gem_cache_directory
      expected_files = [{:name => "gems/rake-0.8.7.gem", :path => "#{FAKE_GEM_PATH}/cache/rake-0.8.7.gem"},
                        {:name => "gems/rspec-1.3.0.gem", :path => "#{FAKE_GEM_PATH}/cache/rspec-1.3.0.gem"},
                        {:name => "gems.yml", :path => "#{Dir.tmpdir}/gems.yml"}]

      subject.should_receive(:installed_gems).once.and_return(@mock_gems)
      subject.should_receive(:export_to_yml).once.and_return("#{Dir.tmpdir}/gems.yml")
      subject.should_receive(:create_tar_file).once.with("snapshot.gems", expected_files)

      subject.export("snapshot.gems")
    end

  end

  
  describe GemsSnapshot::YmlExporter do

    it "should export all installed gems to 'yml' format" do

      Gem.stub!(:sources).and_return { ["http://server1.org", "http://server2.org"] }
      subject.should_receive(:installed_gems).once.and_return(@mock_gems)
      result_file = subject.export("snapshot.yml")

      expected_yml = <<-TXT
--- 
sources: 
- http://server1.org
- http://server2.org
gems: 
- name: rake
  versions: 
  - 0.8.7
- name: rspec
  versions: 
  - 1.3.0
TXT

      File.read(result_file).should eql(expected_yml)
      File.delete(result_file)
    end

  end

end
