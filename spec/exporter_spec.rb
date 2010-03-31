require "gems_snapshot/exporter"
require "ostruct"

describe GemsSnapshot::Exporter do

  before :each do
    @exporter = subject
    @mock_gems = [ OpenStruct.new(:installation_path => "/usr/lib/ruby/gems/1.8", :full_name => "rake-0.8.7"),
                   OpenStruct.new(:installation_path => "/usr/lib/ruby/gems/1.8", :full_name => "rspec-1.3.0") ]
  end

  it "should list 'gem files' of all installed gems" do
    Gem.source_index.should_receive(:search).with(anything).once.and_return @mock_gems
    gems = @exporter.installed_gems

    gems.should_not be_empty
    gems.first.should == "/usr/lib/ruby/gems/1.8/cache/rake-0.8.7.gem"
    gems.last.should == "/usr/lib/ruby/gems/1.8/cache/rspec-1.3.0.gem"
  end

end
