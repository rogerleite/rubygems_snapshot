require "tmpdir"              #necessary to use Dir.tmp

module GemsSnapshot

  class TarImporter

    def import(filename)
      files = extract_files_from_tar(filename)
      copy_gems_to_cache_directory files
      yml_metadata = get_metadata(files)

      yml_importer = GemsSnapshot::YmlImporter.new
      yml_importer.import(yml_metadata)
    end

    private

    def extract_files_from_tar(filename)
      files = []

      tmp_dir = "#{Dir.tmpdir}/#{Time.now.to_i}"
      FileUtils.rm_rf tmp_dir
      FileUtils.mkdir_p tmp_dir

      begin
        File.open(filename, "r") do |file|
          Gem::Package::TarReader.new(file).each_entry do |entry|
            destination_file = "#{tmp_dir}/#{entry.full_name}"
            FileUtils.mkdir_p File.dirname(destination_file)

            File.open(destination_file, "w+") { |f| f.write entry.read }
            files << destination_file
          end
        end
      rescue ex
        raise "An error occurred while extracting files. #{ex.message}"
      end
      files
    end

    def get_metadata(files)
      result = files.select { |file| file =~ /gems.yml$/ }
      raise "File gems.yml not found!" if result.nil? or result.size == 0
      result.first
    end

    def copy_gems_to_cache_directory(files) 
      cache_directory = "#{Gem.path.first}/cache"
      files.select { |file| file =~ /.gem$/ }.each do |file|
        FileUtils.cp file, "#{cache_directory}/#{File.basename(file)}"
      end
    end
  end

end
