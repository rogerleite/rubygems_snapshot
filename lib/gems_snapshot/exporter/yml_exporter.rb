module GemsSnapshot

  class YmlExporter

    include ExporterHelper

    def export(filename)
      gems = installed_gems_obj_to_tuple(installed_gems)
      export_gems(filename, gems)
    end

    def export_gems(filename, gems)
      version_hash  = name_version_hash(gems)
      gems = []
      version_hash.each do |spec_name, versions|
        gems << {'name' => spec_name, 'versions' => versions}
      end
      
      main_hash = {'gems' => gems, 'sources' => Gem.sources}
      #puts main_hash.to_yaml.to_s  #for debug only :P

      File.open(filename, "w") { |file| file.puts(main_hash.to_yaml) }
      filename
    end

    def installed_gems_obj_to_tuple(gems)
      gems.each_with_object([]) do |spec, ar|
        ar << [spec.name.to_s, spec.version.to_s]
      end
    end

    def name_version_hash(name_version_array)
      hash_specs = Hash.new{ |h,k| h[k] = [] }
      name_version_array.each do |name,version|
        hash_specs[name] << version
      end
    end

  end

end
