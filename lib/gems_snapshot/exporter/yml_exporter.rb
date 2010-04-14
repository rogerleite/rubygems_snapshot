module GemsSnapshot

  class YmlExporter

    include ExporterHelper

    def export(filename)
      hash_specs = {}
      installed_gems.each do |spec|
        versions = hash_specs[spec.name.to_s] || []
        versions << spec.version.to_s
        hash_specs[spec.name.to_s] = versions
      end

      gems = []
      hash_specs.each do |spec_name, versions|
        gems << {'name' => spec_name, 'versions' => versions}
      end

      main_hash = {'gems' => gems, 'sources' => Gem.sources}
      #puts main_hash.to_yaml.to_s  #for debug only :P

      File.open(filename, "w") { |file| file.puts(main_hash.to_yaml) }
      filename
    end

  end

end
