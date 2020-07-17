
module GemsSnapshot

  module ExporterHelper

    # List all installed gems
    def installed_gems
      Gem::Specification.each.to_a
    end

  end

  #require all "exporters" from exporter folder
  Dir["#{File.dirname(__FILE__)}/exporter/*_exporter.rb"].each do |file|
    require "gems_snapshot/exporter/#{File.basename(file, ".rb")}"
  end

  class Exporter

    def self.export(filename, options = {})
      options = {:format => :tar}.merge(options)
      format = options.delete(:format)

      begin
        exporter = GemsSnapshot.const_get("#{format.to_s.capitalize}Exporter").send(:new)
        result = exporter.export(filename)
      rescue => ex
        raise Gem::Exception, "Ops! An unexpected error occurred: #{ex.message}"
      end

      result
    end

  end

end
