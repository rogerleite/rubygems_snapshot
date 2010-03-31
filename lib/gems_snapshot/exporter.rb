module GemsSnapshot

  class Exporter

    # Retrieve all gem file from installed gems
    def installed_gems
      dep = Gem::Dependency.new(/^/i, Gem::Requirement.default) #get all local gems
      gems = Gem.source_index.search(dep)

      gems_file = []
      gems.each do |gem|
        gems_file << "#{gem.installation_path}/cache/#{gem.full_name}.gem"
      end
      gems_file
    end

    def pack_file(filename = nil)
      files_content = []
      installed_gems.each do |gem_file|
        files_content << File.read(gem_file)
      end
      filename = "snapshot.gems" if filename.nil?
      File.open(filename, "w") { |file| file.write Marshal.dump(files_content) }
      File.new(filename)
    end

  end

end
