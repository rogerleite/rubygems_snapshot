require 'rubygems/dependency_installer'
require 'yaml'
require_relative '../exporter/yml_exporter'

module GemsSnapshot

  class YmlImporter

    attr :errors

    def initialize()
      @errors = []
    end

    def import(filename)
      yml_hash = YAML.load(File.read(filename))  #TODO: validate file content someday

      yml_hash['gems'].each do |hash_gem|
        gem_name = hash_gem['name']
        hash_gem['versions'].each do |version|
          if available?(gem_name,version)
            puts "#{gem_name}-#{version} already available!"
            next
          end

          gem_name = check_for_cache(gem_name, version)

          puts "Going to install #{gem_name} -v#{version} ... wish me luck!"
          begin
            gem_install(gem_name, version)
          rescue => e
            errors << [gem_name, version]
          end

        end
      end
      exporter = YmlExporter.new
      uninstalled_filename = import_errors_filename(filename)
      exporter.export_gems( uninstalled_filename, errors)
    end

    protected 

    def available?(name,version)
      begin
        Gem::Specification.find_by_name(name, Gem::Requirement.new(version))
      rescue Gem::LoadError
        false
      end
    end

    def import_errors_filename(filename)
      extname = File.extname(filename)
      bare_filename = File.basename(filename, extname )
      "#{bare_filename}_uninstalled#{extname}"
    end


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

