
module GemsSnapshot

  class YmlImporter

    attr :errors

    def import(filename)
      yml_hash = YAML.load(File.read(filename))  #TODO: validate file content someday

      yml_hash['gems'].each do |hash_gem|
        gem_name = hash_gem['name']
        hash_gem['versions'].each do |version|

          if Gem.available? gem_name, version
            puts "#{gem_name}-#{version} already available!"
            next
          end

          gem_name = check_for_cache(gem_name, version)

          puts "Going to install #{gem_name} -v#{version} ... wish me luck!"
          begin
            gem_install(gem_name, version)
          rescue Gem::InstallError => e
            errors << "Error installing #{gem_name}:\n\t#{e.message}"
          rescue Gem::GemNotFoundException => e
            errors << "Gem not found #{e.message}"
          end

        end
      end
    end

    protected 

    #Return gem file if exist at cache folder.
    def check_for_cache(gem_name, version)
      gem_file = "#{gem_name}-#{version}.gem"
      Gem.path.each do |gem_path|
        complete_path = "#{gem_path}/cache/#{gem_file}"
        return complete_path if File.exist? complete_path
      end
      gem_name
    end

    def installer_options
      @installer_options ||= Gem::DependencyInstaller::DEFAULT_OPTIONS.merge({
        :generate_rdoc     => true,
        :generate_ri       => true,
        :format_executable => false,
        :test              => false,
        :version           => Gem::Requirement.default,
        #aditional default parameters
        :ignore_dependencies => true,
        :verbose => true
      })
    end

    def gem_install(gem_name, version, options = installer_options)
      inst = Gem::DependencyInstaller.new(options)
      inst.install(gem_name, version)
      inst.installed_gems.each do |spec|
        puts "Successfully installed #{spec.full_name}"
      end
    end

  end

end
