require "gems_snapshot/exporter"

require "ostruct"
require "fileutils"

include GemsSnapshot

#TODO: find someway to improve these tests

describe GemsSnapshot::Exporter do

  FAKE_GEM_PATH = "/tmp/fake_gem_path"

  before :each do
    @exporter = subject
    @mock_gems = [ OpenStruct.new(:installation_path => FAKE_GEM_PATH, :full_name => "rake-0.8.7", :name => "rake", :version => "0.8.7"),
                   OpenStruct.new(:installation_path => FAKE_GEM_PATH, :full_name => "rspec-1.3.0", :name => "rspec", :version => "1.3.0") ]

    Gem.stub!(:sources).and_return do
      ["http://server1.org", "http://server2.org"]
    end
  end

  def create_fake_gem_cache_directory
    #create fake gem cache directory and fake gem files
    FileUtils.mkdir_p "#{FAKE_GEM_PATH}/cache"
    @mock_gems.each do |gem|
      File.open("#{FAKE_GEM_PATH}/cache/#{gem.full_name}.gem", "w") { |f| f.write gem.full_name }
    end
  end

  it "should export all installed gems to 'tar' format (by default)" do
    create_fake_gem_cache_directory
    expected_files = [{:name => "gems/rake-0.8.7.gem", :path => "#{FAKE_GEM_PATH}/cache/rake-0.8.7.gem"},
      {:name => "gems/rspec-1.3.0.gem", :path => "#{FAKE_GEM_PATH}/cache/rspec-1.3.0.gem"},
      {:name => "gems.yml", :path => "#{Dir.tmpdir}/gems.yml"}]

    @exporter.should_receive(:installed_gems).twice.and_return(@mock_gems)
    @exporter.should_receive(:create_tar_file).once.with("snapshot.gems", expected_files)

    @exporter.export
  end

  it "should export all installed gems to 'yml' format" do
    @exporter.should_receive(:installed_gems).once.and_return(@mock_gems)

    result_file = @exporter.export("snapshot.yml", :format => :yml)

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
