module AssetCrate
  autoload :Config, "asset_crate/config"
  autoload :Packager, "asset_crate/packager"
  
  def self.package!
    Packager.new.package!
  end
end