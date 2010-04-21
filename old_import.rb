require 'rubygems/command'
require 'yaml'

class Gem::Commands::SnapshotCommand < Gem::Command

  def initialize
    super 'snapshot', 'Export/Import your gems.', :format => "tar"

    add_option('-f', '--format FORMAT', 'Snapshot format. Default is "tar". Can be "yml" too.') do |value, options|
      options[:format] = value
    end

  end

  def defaults_str # :nodoc:
    '--format "tar"'
  end

  def arguments # :nodoc:
    args = <<-EOF
          ACTION    'export' or 'import' as action arguments
          FILENAME  file used to export/import actions
    EOF
    return args.gsub(/^\s+/, '')
  end

  def description # :nodoc:
    <<-EOF
Describe here what snapshot does.
Updated description at: http://github.com/rogerleite/rubygems_snapshot
    EOF
  end

  def usage # :nodoc:
    "#{program_name} ACTION(export|import) FILENAME"
  end

  def execute
    action, filename = extract_action(options[:args])
    validate_options(options_without_args)

    if action == "export"
      export(filename)
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

  def export(filename)
    say "Say CHEESE to snapshot! :P"
    filename = GemsSnapshot::Exporter.export(filename, options_without_args)
    say "Gems exported to #{filename} successfully."
  end

  def options_without_args
    options.reject { |key, value| key == :args }
  end

  def validate_options(options)
    format = options[:format]
    format = format.downcase
    unless %w(tar yml).include?(format)
      raise Gem::CommandLineError, "invalid format \"#{format}\" argument.\nUsage:\n#{usage}"
    end
  end

  def extract_action(args)
    action = args[0]
    raise Gem::CommandLineError, "Snapshot needs an action argument.\nUsage:\n#{usage}" if action.nil? or action.empty?

    action = action.downcase
    unless %w(export import).include?(action)
      raise Gem::CommandLineError, "invalid action \"#{action}\" argument.\nUsage:\n#{usage}"
    end

    filename = args[1]
    raise Gem::CommandLineError, "Snapshot needs an filename argument for #{action} action.\nUsage:\n#{usage}" if filename.nil? or filename.empty?
    
    if action == "import"
      raise Gem::Exception, "File not found. :( \nUsage:\n#{usage}" unless File.exist?(filename)
    end

    [action, filename]
  end

end

