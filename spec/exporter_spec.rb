require "gems_snapshot/exporter"

require "ostruct"
require "fileutils"

describe GemsSnapshot::Exporter do

  FAKE_GEM_PATH = "/tmp/fake_gem_path"

  before :each do
    @exporter = subject
    @mock_gems = [ OpenStruct.new(:installation_path => FAKE_GEM_PATH, :full_name => "rake-0.8.7"),
                   OpenStruct.new(:installation_path => FAKE_GEM_PATH, :full_name => "rspec-1.3.0") ]

  end

  it "should list 'gem files' of all installed gems" do
    Gem.source_index.should_receive(:search).with(anything).once.and_return @mock_gems
    gems = @exporter.installed_gems

    gems.should_not be_empty
    gems.first.should == "#{FAKE_GEM_PATH}/cache/rake-0.8.7.gem"
    gems.last.should == "#{FAKE_GEM_PATH}/cache/rspec-1.3.0.gem"
  end

  it "should 'pack' all gem files" do
    #create fake gem cache directory and fake gem files
    FileUtils.mkdir_p "#{FAKE_GEM_PATH}/cache"
    @mock_gems.each do |gem|
      File.open("#{FAKE_GEM_PATH}/cache/#{gem.full_name}.gem", "w") { |f| f.write gem.full_name }
    end
    Gem.source_index.should_receive(:search).with(anything).once.and_return @mock_gems

    result_file = @exporter.pack_file

    File.exist?(result_file).should == true
    
    content = Marshal.load(result_file.read)
    content.first.should == @mock_gems.first.full_name
    content.last.should == @mock_gems.last.full_name

    File.delete result_file.path
  end

end
