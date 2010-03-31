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
      filename = "snapshot.gems" if filename.nil?
      create_tar_file(filename, installed_gems)
      filename
    end

    def create_tar_file(filename, files)
      File.open(filename, "w+") do |file|
        Gem::Package::TarWriter.new(file) do |tar_file|

          files.each do |file_to_include|
            stat = File.stat(file_to_include)
            name = "gems/#{File.basename(file_to_include)}"

            tar_file.add_file_simple(name, stat.mode, stat.size) do |tar_io|
              File.open(file_to_include, "rb") do |file_io|
                tar_io.write(file_io.read(4096)) until file_io.eof?
              end
            end
          end

        end
      end
    end

  end

end
