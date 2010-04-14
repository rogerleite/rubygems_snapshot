
module GemsSnapshot

  module ExporterHelper

    # List all installed gems
    def installed_gems
      dep = Gem::Dependency.new(/^/i, Gem::Requirement.default) #get all local gems
      Gem.source_index.search(dep)
    end

  end

  #require all "exporters" from exporter folder
  Dir["#{File.dirname(__FILE__)}/exporter/*_exporter.rb"].each do |file|
    require "gems_snapshot/exporter/#{File.basename(file)}"
  end

  class Exporter

    def export(filename, options = {})
      options = {:format => :tar}.merge(options)
      format = options.delete(:format)

      begin
        exporter = Kernel.const_get("#{format.to_s.capitalize}Exporter").send(:new)
        result = exporter.export(filename)
      rescue => ex
        raise Gem::Exception, "Ops! An unexpected error occurred: #{ex.message}"
      end

      result
    end

  end

end
