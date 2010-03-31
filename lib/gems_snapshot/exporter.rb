require "rubygems/package"

module GemsSnapshot

  class Exporter

    def export(filename = nil, options = {})
      options = options.merge({:format => :tar})
      if options[:format] == :tar
        result = export_to_tar(filename)
      else
        raise "implement!"
      end
      result
    end

    def installed_gems
      dep = Gem::Dependency.new(/^/i, Gem::Requirement.default) #get all local gems
      Gem.source_index.search(dep)
    end

    def export_to_tar(filename)
      filename = "snapshot.gems" if filename.nil?

      files = []
      installed_gems.each do |gem|
        files << "#{gem.installation_path}/cache/#{gem.full_name}.gem"
      end

      create_tar_file(filename, files)
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