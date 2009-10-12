module AssetCrate
  module Config

    autoload :Crate, "asset_crate/config/crate"
    autoload :File, "asset_crate/config/file"

    def self.from_file(path)
      source = ::File.read(path)
      eval "AssetCrate::Config::File.new {( " + source + "\n )}"
    end

  end
end