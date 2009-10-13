module AssetCrate
  module Config

    autoload :Crate, "asset_crate/config/crate"
    autoload :ConfigFile, "asset_crate/config/config_file"

    def self.from_file(path)
      source = File.read(path)
      eval "AssetCrate::Config::ConfigFile.new {( " + source + "\n )}"
    end

  end
end