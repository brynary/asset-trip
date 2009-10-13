module BlobBundler
  autoload :Blob, "blob_bundler/blob"
  autoload :Compressor, "blob_bundler/compressor"
  autoload :Config, "blob_bundler/config"
  autoload :Manifest, "blob_bundler/manifest"
  autoload :Memoizable, "blob_bundler/memoizable"

  def self.bundle!
    Config.from_file(config_path).bundle!
  end

  def self.app_root
    Pathname.new(".").expand_path
  end
  
  def self.root
    Pathname.new(File.dirname(__FILE__)).join("..").expand_path
  end

  def self.config_path
    app_root.join("config", "blob_bundles.rb")
  end

end