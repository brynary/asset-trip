require "active_support"

module AssetTrip
  autoload :Asset, "asset_trip/asset"
  autoload :Compressor, "asset_trip/compressor"
  autoload :Config, "asset_trip/config"
  autoload :FileWriter, "asset_trip/file_writer"
  autoload :Helper, "asset_trip/helper"
  autoload :Javascript, "asset_trip/javascript"
  autoload :LoadPath, "asset_trip/load_path"
  autoload :Manifest, "asset_trip/manifest"
  autoload :ManifestWriter, "asset_trip/manifest_writer"
  autoload :Middleware, "asset_trip/middleware"
  autoload :Memoizable, "asset_trip/memoizable"
  autoload :SSLStylesheet, "asset_trip/ssl_stylesheet"
  autoload :Stylesheet, "asset_trip/stylesheet"
  autoload :UrlRewriter, "asset_trip/url_rewriter"

  class CompressorError < StandardError
  end

  class UnknownAssetError < StandardError
  end

  class NoManifestError < StandardError
  end

  mattr_accessor :bundle
  self.bundle = true

  def self.bundle!
    config.bundle!
  end

  def self.prune!
    manifest.prune!
  end

  def self.config
    @config ||= Config.from_file(config_path)
  end

  def self.manifest
    raise NoManifestError if @manifest.nil?
    @manifest
  end

  def self.app_root
    Pathname.new(".").expand_path
  end

  def self.root
    Pathname.new(__FILE__).dirname.join("..").expand_path
  end

  def self.assets_path
    app_root.join("public", "assets")
  end

  def self.config_path
    app_root.join("config", "asset_trip")
  end

end
