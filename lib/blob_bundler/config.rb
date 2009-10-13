module BlobBundler
  module Config

    autoload :Crate, "blob_bundler/config/crate"
    autoload :ConfigFile, "blob_bundler/config/config_file"

    def self.from_file(path)
      source = File.read(path)
      eval "BlobBundler::Config::ConfigFile.new {( " + source + "\n )}"
    end

  end
end