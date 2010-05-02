
module GemsSnapshot

  class YmlImporter

    attr :errors

    def import(filename)
      #system "gem install json --no-ri --no-rdoc"  #make cucumber pass! ;D
      yml_hash = YAML.load(File.read(filename))

      yml_hash['gems'].each do |hash_gem|
        gem_name = hash_gem['name']
        hash_gem['versions'].each do |version|

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
