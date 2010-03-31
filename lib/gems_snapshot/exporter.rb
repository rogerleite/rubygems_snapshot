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

  end

end
