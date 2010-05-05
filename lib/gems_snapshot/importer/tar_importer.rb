require "tmpdir"              #necessary to use Dir.tmp

module GemsSnapshot

  class TarImporter

    attr :errors

    def import(filename)
      read_tar(filename)

#      yml_exporter = GemsSnapshot::YmlExporter.new
#      yml_exporter.export("#{Dir.tmpdir}/gems.yml")
    end

    private

    def read_tar(filename)
      files = []

      dir = "#{Dir.tmpdir}/#{Time.now.to_i}"
      FileUtils.rm_rf dir
      FileUtils.mkdir_p dir

      File.open(filename, "r") do |file|
        Gem::Package::TarReader.new(file).each_entry do |entry|

          destination_file = "#{dir}/#{entry.full_name}"
          FileUtils.mkdir_p File.dirname(destination_file)

          File.open(destination_file, "w+") { |f| f.write entry.read }
          files << destination_file
        end
      end
      files
    end

  end

end
