require "gems_snapshot/exporter"

require "ostruct"
require "fileutils"

include GemsSnapshot

describe GemsSnapshot::Exporter do

  FAKE_GEM_PATH = "/tmp/fake_gem_path"

  before :each do
    @exporter = subject
    @mock_gems = [ OpenStruct.new(:installation_path => FAKE_GEM_PATH, :full_name => "rake-0.8.7"),
                   OpenStruct.new(:installation_path => FAKE_GEM_PATH, :full_name => "rspec-1.3.0") ]

  end

  def create_fake_gem_cache_directory
    #create fake gem cache directory and fake gem files
    FileUtils.mkdir_p "#{FAKE_GEM_PATH}/cache"
    @mock_gems.each do |gem|
      File.open("#{FAKE_GEM_PATH}/cache/#{gem.full_name}.gem", "w") { |f| f.write gem.full_name }
    end
  end

  it "by default, should export all installed gems to 'tar' format" do
    create_fake_gem_cache_directory

    @exporter.should_receive(:installed_gems).once.and_return(@mock_gems)
    @exporter.should_receive(:create_tar_file).once.with("snapshot.gems", instance_of(Array))

    @exporter.export
  end

end
