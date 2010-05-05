module GemsSnapshot

  #require all "importers" from importer folder
  Dir["#{File.dirname(__FILE__)}/importer/*_importer.rb"].each do |file|
    require "gems_snapshot/importer/#{File.basename(file, ".rb")}"
  end

  class Importer

    def self.import(filename, options = {})
      options = {:format => :tar}.merge(options)
      format = options.delete(:format)

      begin
        importer = GemsSnapshot.const_get("#{format.to_s.capitalize}Importer").send(:new)
        importer.import(filename)
      rescue => ex
        raise Gem::Exception, "Ops! An unexpected error occurred: #{ex.message}"
      end

    end

  end

end
