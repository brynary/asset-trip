module BlobBundler
  autoload :Config, "blob_bundler/config"
  autoload :Packager, "blob_bundler/packager"

  def self.package!
    Packager.new.package!
  end
end