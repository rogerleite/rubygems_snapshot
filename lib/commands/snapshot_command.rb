require 'rubygems/command'
require 'yaml'

class Gem::Commands::SnapshotCommand < Gem::Command

  def initialize
    super 'snapshot', 'Export/Import your installed gems'
  end

  def arguments # :nodoc:
    args = <<-EOF
          export    export your installed gems to yml file
          import    install allgems from yml file
          filename  yml file used to export/import actions
    EOF
    return args.gsub(/^\s+/, '')
  end

  def description # :nodoc:
    <<-EOF
Describe here what snapshot does.
    EOF
  end

  def usage # :nodoc:
    "#{program_name} action(export|import) filename"
  end

  def execute
    action, filename = get_and_check_arguments(options[:args])

    if action == "export"
      export(action, filename)
    else
      import(action, filename)
    end
  end

  private

  def import(action, filename)
    #TODO: check if is a valid yml file

    require 'rubygems/dependency_installer'

    main_hash = nil
    File.open(filename, "r") do |file|
      main_hash = YAML.load(file)
    end
    
    main_hash['sources'].each do |source|
      Gem.sources << source unless Gem.sources.include?(source)
    end

    options = Gem::DependencyInstaller::DEFAULT_OPTIONS.merge({
      :generate_rdoc     => true,
      :generate_ri       => true,
      :format_executable => false,
      :test              => false,
      :version           => Gem::Requirement.default,
      #aditional default parameters
      :ignore_dependencies => true,
      :verbose => true
    })

    main_hash['gems'].each do |hash_gem|
      gem_name = hash_gem['name']
      hash_gem['versions'].each do |version|

        say "Going to install #{gem_name} -v#{version} ... wish me luck!"
        begin
          gem_install(options, gem_name, version)

        rescue Gem::InstallError => e
          alert_error("Error installing #{gem_name}:\n\t#{e.message}")
        rescue Gem::GemNotFoundException => e
          alert_error(e.message)
        end

      end
    end

  end

  def gem_install(options, gem_name, version)
    inst = Gem::DependencyInstaller.new(options)
    inst.install(gem_name, version)

    inst.installed_gems.each do |spec|
      say "Successfully installed #{spec.full_name}"
    end
  end

  def list_installed_gems
    name = /^/i  #get all local gems
    dep = Gem::Dependency.new(name, Gem::Requirement.default)
    specs = Gem.source_index.search(dep)
  end

  def export(action, filename)
    say "Say CHEESE to snapshot! :P"

    specs = list_installed_gems

    hash_specs = {}
    specs.each do |spec|
      versions = hash_specs[spec.name.to_s] || []
      versions << spec.version.to_s
      hash_specs[spec.name.to_s] = versions
    end

    gems = []
    hash_specs.each do |spec_name, versions|
      gems << {'name' => spec_name, 'versions' => versions}
    end

    main_hash = {'gems' => gems, 'sources' => Gem.sources}
    #say main_hash.to_yaml.to_s  #for debug only :P

    File.open(filename, "w") do |file|
      file.puts(main_hash.to_yaml)
    end
    say "Gems exported to #{filename} successfully."
  end

  def get_and_check_arguments(args)
    action = args[0]
    raise Gem::CommandLineError, "Snapshot needs an action argument.\nUsage:\n#{usage}" if action.nil? or action.empty?

    action = action.downcase
    unless %w(export import).include?(action)
      raise Gem::CommandLineError, "invalid action \"#{action}\" argument.\nUsage:\n#{usage}"
    end

    filename = nil
    if action == "export"
      filename = args[1] || "gems_#{Time.now.strftime("%Y%m%d_%H%M")}.yml"
      filename = filename.downcase
      filename.concat(".yml") unless filename.end_with?(".yml")
    else
      filename = args[1]
      raise Gem::CommandLineError, "Snapshot needs an filename argument for import action.\nUsage:\n#{usage}" if filename.nil? or filename.empty?
      raise Gem::Exception, "File not found. :( \nUsage:\n#{usage}" unless File.exist?(filename)
    end

    [action, filename]
  end

end

