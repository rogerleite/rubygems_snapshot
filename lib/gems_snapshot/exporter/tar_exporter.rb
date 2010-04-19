require "tmpdir"              #necessary to use Dir.tmp
require "rubygems/package"    #necessary to use Gem::Package::TarWriter

module GemsSnapshot

  class TarExporter
    
    include ExporterHelper

    def export(filename)
      filename = "snapshot.gems" if filename.nil?

      files = []
      installed_gems.each do |gem|
        files << {:name => "gems/#{gem.full_name}.gem", :path => "#{gem.installation_path}/cache/#{gem.full_name}.gem"}
      end
      files << {:name => "gems.yml", :path => export_to_yml("#{Dir.tmpdir}/gems.yml")}

      create_tar_file(filename, files)
      filename
    end

    def export_to_yml(filename)
      yml_exporter = GemsSnapshot::YmlExporter.new
      yml_exporter.export("#{Dir.tmpdir}/gems.yml")
    end

    # Create a tar file with Gem::Package::TarWriter from Rubygems.
    # +filename+ file destination.
    # +files+ Array of Hash. Each hash have to be +:name+ and +:path+ keys.
    def create_tar_file(filename, files)
      File.open(filename, "w+") do |file|
        Gem::Package::TarWriter.new(file) do |tar_file|

          files.each do |hash|
            next unless File.exists?(hash[:path])

            filepath = hash[:path]
            filename = hash[:name]

            stat = File.stat(filepath)
            tar_file.add_file_simple(filename, stat.mode, stat.size) do |tar_io|
              File.open(filepath, "rb") do |file_io|
                tar_io.write(file_io.read(4096)) until file_io.eof?
              end
            end
          end

        end
      end
    end

  end

end
